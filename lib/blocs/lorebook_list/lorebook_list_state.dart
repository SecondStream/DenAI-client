part of 'lorebook_list_bloc.dart';

abstract class LorebookListState {}

class LorebookListInitialState extends LorebookListState {}

class LorebookListLoadingState extends LorebookListState {}

class LorebookListLoadedState extends LorebookListState {
  final List<Lorebook> lorebooks;
  LorebookListLoadedState(this.lorebooks);
}

class LorebookListErrorState extends LorebookListState {
  final ErrType errType;
  final Object error;

  LorebookListErrorState(this.errType, this.error);
}
