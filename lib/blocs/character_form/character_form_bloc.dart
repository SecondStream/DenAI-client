import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:den_ai/clients/openai_client.dart';
import 'package:den_ai/managers/lore_vector_storage.dart';
import 'package:den_ai/repositories/lorebooks_repository.dart';
import 'package:den_ai/repositories/settings_repository.dart';
import 'package:den_ai/tools/character_card_tool.dart';
import 'package:den_ai/tools/file_tool.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/characters_repository.dart';
import 'package:path_provider/path_provider.dart';

part 'character_form_event.dart';

part 'character_form_state.dart';

class CharacterFormBloc extends Bloc<CharacterFormEvent, CharacterFormState> {
  final CharactersRepository _repository;
  final LorebooksRepository _loreRepository;
  final SettingsRepository _settingsRepository;
  final OpenAIClient _client;
  final LoreVectorStorage _vectorStorage;

  CharacterFormBloc(
    this._repository,
    this._loreRepository,
    this._settingsRepository,
    this._client,
    this._vectorStorage,
  ) : super(CharacterFormInitialState()) {
    on<SubmitCharacterFormEvent>(_onSubmitForm);
    on<DeleteCharacterEvent>(_onDeleteCharacter);
    on<InitCharacterFormEvent>(_onInitCharacterForm);
    on<SelectedCardEvent>(_onSelectedCard);
    on<ExportCardEvent>(_onExportCard);
  }

  Future<void> _onInitCharacterForm(
    InitCharacterFormEvent event,
    Emitter<CharacterFormState> emit,
  ) async {
    emit(CharacterFormLoadingState());
    try {
      List<Lorebook> allLorebooks = [];
      try {
        allLorebooks = await _loreRepository.getAllLorebooks();
      } catch (_) {}
      Char? char;
      List<int> selectedIds = [];
      if (event.characterId != null) {
        char = await _repository.getCharacterById(event.characterId!);
        selectedIds = char?.lorebooks.map((b) => b.id).toList() ?? [];
      }
      emit(
        CharacterFormLoadedState(
          character: char,
          allLorebooks: allLorebooks,
          selectedLorebookIds: selectedIds,
        ),
      );
    } catch (e) {
      emit(CharacterFormErrorState(ErrType.loadCharacter, e));
    }
  }

  Future<void> _onSelectedCard(SelectedCardEvent event, Emitter<CharacterFormState> emit) async {
    final currentState = state;
    if (currentState is! CharacterFormLoadedState) return;

    emit(CharacterFormLoadingState());

    try {
      final bytes = await event.card.readAsBytes();
      final (importedData, isPng) = CharacterCardTool.importCard(bytes);

      if (importedData == null) {
        throw Exception('Не удалось распарсить карточку персонажа');
      }

      String? localAvatarPath = isPng ? await FileTool.saveAvatar(event.card) : null;
      final bookIds = <int>[];

      final booksToImport = importedData.lorebooks.take(3);

      for (final book in booksToImport) {
        final List<String> entryTexts = book.entries
            .map((e) => '${e.title}\n${e.content}')
            .where((content) => content.isNotEmpty)
            .toList();

        List<List<double>> embeddings = [];

        if (entryTexts.isNotEmpty) {
          final settings = await _settingsRepository.getSettings();
          embeddings = await _client.getEmbeddings(texts: entryTexts, settings: settings);
        }

        final Lorebook newBook = await _loreRepository.saveLorebook(
          name: book.name,
          about: book.description,
        );

        Lorebook? updatedBook;
        for (final entry in book.entries) {
          (updatedBook, _) = await _loreRepository.saveLoreEntry(
            null,
            newBook.id,
            entry.title,
            entry.content,
          );
        }

        if (updatedBook != null && embeddings.isNotEmpty) {
          _vectorStorage.saveVectors(updatedBook.id, embeddings);
        }

        bookIds.add(newBook.id);
      }

      final Char newChar = await _repository.saveCharacter(
        id: currentState.character?.id,
        name: importedData.name,
        avatarPath: localAvatarPath,
        appearance: importedData.description,
        personality: importedData.personality,
        scenario: importedData.scenario,
        greeting: importedData.greeting,
        prompt: importedData.instructions,
        lorebookIds: bookIds,
        cropData: null,
      );

      emit(CharacterFormSuccessState(newChar));
    } catch (e) {
      emit(CharacterFormErrorState(ErrType.loadCharacter, e));
      emit(currentState.copy());
    }
  }

  void _onSubmitForm(SubmitCharacterFormEvent event, Emitter<CharacterFormState> emit) async {
    emit(CharacterFormLoadingState());
    String? avatarPath;
    String? backgroundPath;
    if (event.avatarFile != null) {
      avatarPath = await FileTool.saveAvatar(event.avatarFile!);
    }
    if (event.backgroundFile != null) {
      backgroundPath = await FileTool.saveBackground(event.backgroundFile!);
    }
    try {
      final savedChar = await _repository.saveCharacter(
        id: event.id,
        name: event.name,
        appearance: event.appearance,
        personality: event.personality,
        scenario: event.scenario,
        greeting: event.greeting,
        prompt: event.prompt,
        avatarPath: avatarPath,
        cropData: event.cropData,
        backgroundPath: backgroundPath,
        lorebookIds: event.lorebookIds,
      );
      emit(CharacterFormSuccessState(savedChar));
    } catch (e) {
      emit(CharacterFormErrorState(ErrType.saveCharacter, e));
    }
  }

  void _onDeleteCharacter(DeleteCharacterEvent event, Emitter<CharacterFormState> emit) async {
    emit(CharacterFormLoadingState());
    try {
      await _repository.deleteCharacter(event.id);
      emit(CharacterDeleteSuccessState());
    } catch (e) {
      emit(CharacterFormErrorState(ErrType.saveCharacter, e));
    }
  }

  Future<void> _onExportCard(ExportCardEvent event, Emitter<CharacterFormState> emit) async {
    final currentState = state;
    if (currentState is! CharacterFormLoadedState) return;
    emit(CharacterFormLoadingState());
    try {
      final lorebooks = (event.lorebookIds.isNotEmpty)
          ? await _loreRepository.getLorebooks(event.lorebookIds)
          : <Lorebook>[];
      final character = Char(
        id: -1,
        name: event.name,
        lorebooks: lorebooks,
        appearance: event.appearance,
        personality: event.personality,
        scenario: event.scenario,
        greeting: event.greeting,
        prompt: event.prompt,
      );

      Uint8List? avatar = event.avatarFile != null ? await event.avatarFile!.readAsBytes() : null;

      if (avatar == null && event.id != null) {
        final char = await _repository.getCharacterById(event.id!);
        if (char != null) {
          final docDir = (await getApplicationDocumentsDirectory()).path;
          final avatarPath = char.getAvatar(docDir);
          if (avatarPath != null) {
            avatar = await File(avatarPath).readAsBytes();
          }
        }
      }

      final res = await CharacterCardTool.exportCard(character: character, avatarBytes: avatar);

      emit(
        CharacterFormExportCardSucessState(
          json: res.cardJson,
          image: res.cardPng,
          name: character.name.isNotEmpty ? character.name : 'character_card',
        ),
      );

      emit(currentState.copy());
    } catch (e) {
      emit(CharacterFormErrorState(ErrType.saveCharacter, e));
    }
  }
}
