import 'dart:async';
import 'dart:io';
import 'package:den_ai/repositories/lorebooks_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/characters_repository.dart';

part 'character_form_event.dart';

part 'character_form_state.dart';

class CharacterFormBloc extends Bloc<CharacterFormEvent, CharacterFormState> {
  final CharactersRepository _repository;
  final LorebooksRepository _loreRepository;

  CharacterFormBloc(this._repository, this._loreRepository)
    : super(CharacterFormInitialState()) {
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

  Future<void> _onSelectedCard(
    SelectedCardEvent event,
    Emitter<CharacterFormState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CharacterFormLoadedState) return;
    emit(CharacterFormLoadingState());
    try {
      final char = await _repository.loadByCard(event.card);
      final avatarPath = char.getAvatar(event.baseUrl);
      var avatar = avatarPath != null
          ? await _repository.loadAvatar(avatarPath)
          : null;
      List<Lorebook> allLorebooks = currentState.allLorebooks;
      if (char.lorebooks.isNotEmpty) {
        try {
          allLorebooks = await _loreRepository.getAllLorebooks();
        } catch (_) {}
      }
      emit(
        CharacterFormLoadedCardState(
          character: char,
          allLorebooks: allLorebooks,
          selectedLorebookIds: char.lorebooks.isNotEmpty ? char.lorebooks.map((e) => e.id).toList() : [],
          avatar: avatar,
        ),
      );
      //TODO: Временная затычка, надо убрать и сделать по человечески.
      await Future.delayed(Duration(milliseconds: 100));
      emit((state as CharacterFormLoadedState).copy());
    } catch (e) {
      emit(CharacterFormErrorState(ErrType.loadCharacter, e));
    }
  }

  void _onSubmitForm(
    SubmitCharacterFormEvent event,
    Emitter<CharacterFormState> emit,
  ) async {
    emit(CharacterFormLoadingState());
    try {
      final savedChar = await _repository.saveCharacter(
        id: event.id,
        name: event.name,
        appearance: event.appearance,
        personality: event.personality,
        scenario: event.scenario,
        greeting: event.greeting,
        prompt: event.prompt,
        avatarFile: event.avatarFile,
        cropData: event.cropData,
        backgroundFile: event.backgroundFile,
        lorebookIds: event.lorebookIds,
      );
      emit(CharacterFormSuccessState(savedChar));
    } catch (e) {
      emit(CharacterFormErrorState(ErrType.saveCharacter, e));
    }
  }

  void _onDeleteCharacter(
    DeleteCharacterEvent event,
    Emitter<CharacterFormState> emit,
  ) async {
    emit(CharacterFormLoadingState());
    try {
      await _repository.deleteCharacter(event.id);
      emit(CharacterDeleteSuccessState());
    } catch (e) {
      emit(CharacterFormErrorState(ErrType.saveCharacter, e));
    }
  }

  Future<void> _onExportCard(
    ExportCardEvent event,
    Emitter<CharacterFormState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CharacterFormLoadedState) return;
    emit(CharacterFormLoadingState());
    try {
      final remotePath = await _repository.exportCard(
        id: event.id,
        name: event.name,
        appearance: event.appearance,
        personality: event.personality,
        scenario: event.scenario,
        greeting: event.greeting,
        prompt: event.prompt,
        lorebookIds: event.lorebookIds,
        avatarFile: event.avatarFile,
      );

      final file = await _repository.loadAvatar('${event.baseUrl}/$remotePath');
      if (file != null) {
        await file.copy(event.path);
      }
      emit(currentState.copy());
    } catch (e) {
      emit(CharacterFormErrorState(ErrType.saveCharacter, e));
    }
  }
}
