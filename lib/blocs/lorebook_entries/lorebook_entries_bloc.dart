import 'package:den_ai/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:den_ai/repositories/lorebooks_repository.dart';
import 'package:den_ai/blocs/lorebook_entries/lorebook_entries_event.dart';
import 'package:den_ai/blocs/lorebook_entries/lorebook_entries_state.dart';

class LorebookEntriesBloc extends Bloc<LorebookEntriesEvent, LorebookEntriesState> {
  final LorebooksRepository _repository;

  LorebookEntriesBloc(this._repository) : super(LorebookEntriesInitialState()) {
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
      await _repository.deleteLoreEntry(event.entryId);

      final updatedEntries = List<LoreEntry>.from(currentState.lorebook.entries)
        ..removeWhere((e) => e.id == event.entryId);

      final updatedBook = Lorebook(
        id: currentState.lorebook.id,
        name: currentState.lorebook.name,
        about: currentState.lorebook.about,
        cover: currentState.lorebook.cover,
        crop: currentState.lorebook.crop,
        entries: updatedEntries,
        avatar: null,
      );
      emit(LorebookEntriesLoadedState(updatedBook));
    } catch (e) {
      emit(LorebookEntriesErrorState(e.toString()));
    }
  }

  Future<void> _onSaveEntry(SaveEntryEvent event, Emitter<LorebookEntriesState> emit) async {
    if (state is! LorebookEntriesLoadedState) return;
    try {
      final updatedBook = await _repository.saveLoreEntry(event.entry);
      emit(LorebookEntriesLoadedState(updatedBook));
    } catch (e) {
      emit(LorebookEntriesErrorState(e.toString()));
    }
  }
}
