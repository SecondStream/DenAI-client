part of 'character_form_bloc.dart';

abstract class CharacterFormState {}

class CharacterFormInitialState extends CharacterFormState {}

class CharacterFormLoadingState extends CharacterFormState {}

class CharacterFormSuccessState extends CharacterFormState {
  final Char character;
  CharacterFormSuccessState(this.character);
}

class CharacterFormErrorState extends CharacterFormState {
  final ErrType errType;
  final Object error;

  CharacterFormErrorState(this.errType, this.error);
}

class CharacterDeleteSuccessState extends CharacterFormState {}
