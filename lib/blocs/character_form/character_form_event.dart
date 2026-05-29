part of 'character_form_bloc.dart';

abstract class CharacterFormEvent {}

class SubmitCharacterFormEvent extends CharacterFormEvent {
  final int? id;
  final String name;
  final String appearance;
  final String personality;
  final String scenario;
  final String greeting;
  final String prompt;
  final File? avatarFile;
  final File? backgroundFile;

  SubmitCharacterFormEvent({
    this.id,
    required this.name,
    required this.appearance,
    required this.personality,
    required this.scenario,
    required this.greeting,
    required this.prompt,
    this.avatarFile,
    this.backgroundFile,
  });
}

class DeleteCharacterEvent extends CharacterFormEvent {
  final int id;
  DeleteCharacterEvent(this.id);
}
