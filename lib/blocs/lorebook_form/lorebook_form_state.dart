part of 'lorebook_form_bloc.dart';

abstract class LorebookFormState {}

class LorebookFormInitialState extends LorebookFormState {}

class LorebookFormLoadingState extends LorebookFormState {}

class LorebookFormSuccessState extends LorebookFormState {
  final Lorebook lorebook;
  LorebookFormSuccessState(this.lorebook);
}

class LorebookFormErrorState extends LorebookFormState {
  final ErrType errType;
  final Object error;

  LorebookFormErrorState(this.errType, this.error);
}

class LorebookFormDeleteSuccessState extends LorebookFormState {}
