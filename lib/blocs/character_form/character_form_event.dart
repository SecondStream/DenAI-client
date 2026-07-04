part of 'character_form_bloc.dart';

abstract class CharacterFormEvent {
  const CharacterFormEvent();
}

class InitCharacterFormEvent extends CharacterFormEvent {
  final int? characterId;

  const InitCharacterFormEvent(this.characterId);
}

class SubmitCharacterFormEvent extends CharacterFormEvent {
  final int? id;
  final String name;
  final String appearance;
  final String personality;
  final String scenario;
  final String greeting;
  final String prompt;
  final File? avatarFile;
  final CropData? cropData;
  final File? backgroundFile;
  final List<int> lorebookIds;

  const SubmitCharacterFormEvent({
    this.id,
    required this.name,
    required this.appearance,
    required this.personality,
    required this.scenario,
    required this.greeting,
    required this.prompt,
    required this.lorebookIds,
    this.avatarFile,
    this.cropData,
    this.backgroundFile,
  });
}

class ExportCardEvent extends CharacterFormEvent {
  final String path;
  final String baseUrl;
  final int? id;
  final String name;
  final String appearance;
  final String personality;
  final String scenario;
  final String greeting;
  final String prompt;
  final File? avatarFile;
  final List<int> lorebookIds;

  ExportCardEvent({
    required this.path,
    required this.baseUrl,
    this.id,
    required this.name,
    required this.appearance,
    required this.personality,
    required this.scenario,
    required this.greeting,
    required this.prompt,
    required this.lorebookIds,
    this.avatarFile,
  });
}

class DeleteCharacterEvent extends CharacterFormEvent {
  final int id;

  const DeleteCharacterEvent(this.id);
}

class SelectedCardEvent extends CharacterFormEvent {
  final File card;
  final String baseUrl;

  const SelectedCardEvent(this.card, this.baseUrl);
}
