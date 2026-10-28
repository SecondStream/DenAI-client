part of 'user_card_form_bloc.dart';

abstract class UserCardFormEvent {}

class ShownUserCardEvent extends UserCardFormEvent {
  final int? id;
  ShownUserCardEvent(this.id);
}

class SubmitUserCardFormEvent extends UserCardFormEvent {
  final int? id;
  final String name;
  final String description;
  final bool isDefault;
  final File? avatarFile;
  final CropData? cropData;

  SubmitUserCardFormEvent({
    this.id,
    required this.name,
    required this.description,
    required this.isDefault,
    this.avatarFile,
    this.cropData,
  });
}

class DeleteUserCardEvent extends UserCardFormEvent {
  final int id;
  DeleteUserCardEvent(this.id);
}
