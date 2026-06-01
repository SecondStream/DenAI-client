import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/characters_repository.dart';

part 'character_form_event.dart';
part 'character_form_state.dart';

class CharacterFormBloc extends Bloc<CharacterFormEvent, CharacterFormState> {
  final CharactersRepository _repository;

  CharacterFormBloc(this._repository) : super(CharacterFormInitialState()) {
    on<SubmitCharacterFormEvent>(_onSubmitForm);
    on<DeleteCharacterEvent>(_onDeleteCharacter);
  }

  void _onSubmitForm(SubmitCharacterFormEvent event, Emitter<CharacterFormState> emit) async {
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
        backgroundFile: event.backgroundFile,
      );
      emit(CharacterFormSuccessState(savedChar));
    } catch (e) {
      emit(CharacterFormErrorState(ErrType.saveCharacter, e));
    }
  }

  void _onDeleteCharacter(DeleteCharacterEvent event, Emitter<CharacterFormState> emit) async {
    emit(CharacterFormLoadingState());
    try {
      await _repository.deleteCharacter(event.id);
      emit(CharacterDeleteSuccessState());
    } catch (e) {
      emit(CharacterFormErrorState(ErrType.saveCharacter, e));
    }
  }
}
