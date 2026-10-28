import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/blocs/notify/notify_bloc.dart';
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
  final NotifyBloc _notification;

  LorebookEntriesBloc(this._repository, this.vectorStorage, this.client, this.settingsRepository, this._notification)
    : super(LorebookEntriesInitialState()) {
    on<LoadEntriesEvent>(_onLoadEntries);
    on<DeleteEntryEvent>(_onDeleteEntry);
    on<SaveEntryEvent>(_onSaveEntry);
  }

  Future<void> _onLoadEntries(LoadEntriesEvent event, Emitter<LorebookEntriesState> emit) async {
    emit(LorebookEntriesLoadingState());
    try {
      final entries = await _repository.getLoreEntries(event.bookId);
      emit(LorebookEntriesLoadedState(entries));
    } catch (e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.loadLoreEntries));
      emit(LorebookEntriesLoadedState([]));
    }
  }

  Future<void> _onDeleteEntry(DeleteEntryEvent event, Emitter<LorebookEntriesState> emit) async {
    final currentState = state;
    if (currentState is! LorebookEntriesLoadedState) return;

    try {
      final lorebook = await _repository.getLorebook(event.bookId);
      final updatedEntries = List<LoreEntry>.from(currentState.entries)
        ..removeWhere((e) => e.id == event.entryId);

      final updatedBook = lorebook.copyWith(entries: updatedEntries);

      final texts = updatedBook.getEntriesTexts();
      if (texts.isNotEmpty) {
        final settings = await settingsRepository.getSettings();
        final embeddings = await client.getEmbeddings(texts: texts, settings: settings);
        vectorStorage.saveVectors(updatedBook.id, embeddings);
      } else {
        vectorStorage.deleteVectors(updatedBook.id);
      }
      await _repository.deleteLoreEntry(event.entryId);

      emit(LorebookEntriesLoadedState(updatedBook.entries));
    } catch (e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.remove));
      emit(currentState.copy());
    }
  }

  Future<void> _onSaveEntry(SaveEntryEvent event, Emitter<LorebookEntriesState> emit) async {
    final currentState = state;
    if (currentState is! LorebookEntriesLoadedState) return;
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
      emit(LorebookEntriesLoadedState(updatedBook.entries));
    } catch (e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.save));
      emit(currentState.copy());
    }
  }
}
