part of 'lorebook_form_bloc.dart';

abstract class LorebookFormState {}

class LorebookFormInitialState extends LorebookFormState {}

class LorebookFormLoadingState extends LorebookFormState {}

class LorebookFormSuccessState extends LorebookFormState {
  final Lorebook? lorebook;
  LorebookFormSuccessState({this.lorebook});

  LorebookFormSuccessState copy() {
    return LorebookFormSuccessState(lorebook: lorebook);
  }
}

class LorebookFormErrorState extends LorebookFormState {
  final ErrType errType;
  final Object error;

  LorebookFormErrorState(this.errType, this.error);
}

class LorebookFormSaveSuccessState extends LorebookFormState {}

class LorebookFormDeleteSuccessState extends LorebookFormState {}
