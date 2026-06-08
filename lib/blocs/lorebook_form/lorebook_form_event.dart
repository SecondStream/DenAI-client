part of 'lorebook_form_bloc.dart';

abstract class LorebookFormEvent {}

class SubmitLorebookFormEvent extends LorebookFormEvent {
  final int? id;
  final String name;
  final String about;
  final File? coverFile;
  final CropData? cropData;

  SubmitLorebookFormEvent({
    this.id,
    required this.name,
    required this.about,
    this.coverFile,
    this.cropData,
  });
}

class DeleteLorebookEvent extends LorebookFormEvent {
  final int id;
  DeleteLorebookEvent(this.id);
}
