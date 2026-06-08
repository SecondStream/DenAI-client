import 'package:den_ai/repositories/lorebooks_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';

part 'lorebook_list_event.dart';
part 'lorebook_list_state.dart';

class LorebookListBloc extends Bloc<LorebookListEvent, LorebookListState> {
  final LorebooksRepository _repository;

  LorebookListBloc(this._repository) : super(LorebookListInitialState()) {
    on<LoadAllLorebooksEvent>(_onLoadAllLorebooks);
  }

  Future<void> _onLoadAllLorebooks(
    LoadAllLorebooksEvent event,
    Emitter<LorebookListState> emit,
  ) async {
    emit(LorebookListLoadingState());
    try {
      final list = await _repository.getAllLorebooks();
      emit(LorebookListLoadedState(list));
    } catch (e) {
      emit(LorebookListErrorState(ErrType.loadLoreEntries, e));
    }
  }
}
