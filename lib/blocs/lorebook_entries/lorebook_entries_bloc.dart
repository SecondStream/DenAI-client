import 'package:den_ai/clients/openai_client.dart';
import 'package:den_ai/managers/lore_vector_storage.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:den_ai/repositories/lorebooks_repository.dart';
import 'package:den_ai/blocs/lorebook_entries/lorebook_entries_event.dart';
import 'package:den_ai/blocs/lorebook_entries/lorebook_entries_state.dart';

class LorebookEntriesBloc extends Bloc<LorebookEntriesEvent, LorebookEntriesState> {
  final LorebooksRepository _repository;
  final LoreVectorStorage vectorStorage;
  final OpenAIClient client;
  final SettingsRepository settingsRepository;

  LorebookEntriesBloc(this._repository, this.vectorStorage, this.client, this.settingsRepository)
    : super(LorebookEntriesInitialState()) {
    on<LoadEntriesEvent>(_onLoadEntries);
    on<DeleteEntryEvent>(_onDeleteEntry);
    on<SaveEntryEvent>(_onSaveEntry);
  }

  Future<void> _onLoadEntries(LoadEntriesEvent event, Emitter<LorebookEntriesState> emit) async {
    emit(LorebookEntriesLoadingState());
    try {
      final book = await _repository.getLorebook(event.bookId);
      emit(LorebookEntriesLoadedState(book));
    } catch (e) {
      emit(LorebookEntriesErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteEntry(DeleteEntryEvent event, Emitter<LorebookEntriesState> emit) async {
    final currentState = state;
    if (currentState is! LorebookEntriesLoadedState) return;

    try {
      final updatedEntries = List<LoreEntry>.from(currentState.lorebook.entries)
        ..removeWhere((e) => e.id == event.entryId);

      final updatedBook = Lorebook(
        id: currentState.lorebook.id,
        name: currentState.lorebook.name,
        about: currentState.lorebook.about,
        cover: currentState.lorebook.cover,
        crop: currentState.lorebook.crop,
        entries: updatedEntries,
      );

      final texts = updatedBook.getEntriesTexts();
      if (texts.isNotEmpty) {
        final settings = await settingsRepository.getSettings();
        final embeddings = await client.getEmbeddings(texts: texts, settings: settings);
        vectorStorage.saveVectors(updatedBook.id, embeddings);
      } else {
        vectorStorage.deleteVectors(updatedBook.id);
      }
      await _repository.deleteLoreEntry(event.entryId);

      emit(LorebookEntriesLoadedState(updatedBook));
    } catch (e) {
      emit(LorebookEntriesErrorState(e.toString()));
    }
  }

  Future<void> _onSaveEntry(SaveEntryEvent event, Emitter<LorebookEntriesState> emit) async {
    if (state is! LorebookEntriesLoadedState) return;
    try {
      final (updatedBook, id) = await _repository.saveLoreEntry(
        event.id,
        event.lorebookId,
        event.title,
        event.content,
      );

      try {
        final texts = updatedBook.getEntriesTexts();
        if (texts.isNotEmpty) {
          final settings = await settingsRepository.getSettings();
          final embeddings = await client.getEmbeddings(texts: texts, settings: settings);
          vectorStorage.saveVectors(updatedBook.id, embeddings);
        } else {
          vectorStorage.deleteVectors(updatedBook.id);
        }
      } catch (e) {
        if (id != null) await _repository.deleteLoreEntry(id);
      }
      emit(LorebookEntriesLoadedState(updatedBook));
    } catch (e) {
      emit(LorebookEntriesErrorState(e.toString()));
    }
  }
}
