part of 'character_form_bloc.dart';

abstract class CharacterFormState {
  const CharacterFormState();
}

class CharacterFormInitialState extends CharacterFormState {}

class CharacterFormLoadingState extends CharacterFormState {}

class CharacterFormLoadedState extends CharacterFormState {
  final Char? character;
  final List<Lorebook> allLorebooks;
  final List<int> selectedLorebookIds;

  const CharacterFormLoadedState({
    this.character,
    required this.allLorebooks,
    required this.selectedLorebookIds,
  });

  CharacterFormLoadedState copy() {
    return CharacterFormLoadedState(
      character: character,
      allLorebooks: allLorebooks,
      selectedLorebookIds: selectedLorebookIds,
    );
  }
}

class CharacterFormLoadedCardState extends CharacterFormLoadedState {
  final File? avatar;

  const CharacterFormLoadedCardState({
    super.character,
    required super.allLorebooks,
    required super.selectedLorebookIds,
    this.avatar,
  });
}

class CharacterFormSuccessState extends CharacterFormState {
  final Char character;

  const CharacterFormSuccessState(this.character);
}

class CharacterFormErrorState extends CharacterFormState {
  final ErrType errType;
  final Object error;

  const CharacterFormErrorState(this.errType, this.error);
}

class CharacterDeleteSuccessState extends CharacterFormState {
  const CharacterDeleteSuccessState();
}
