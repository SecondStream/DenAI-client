part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class LoadAllSettingsEvent extends SettingsEvent {}

class SaveSettingsEvent extends SettingsEvent {
  final SettingsBase settings;
  final ModelView model;
  final ModelView modelVision;
  final ModelView modelEmbedding;
  SaveSettingsEvent(this.settings, this.model, this.modelVision, this.modelEmbedding);
}

class SaveProviderEvent extends SettingsEvent {
  final int? id;
  final String name;
  final String url;
  final String key;
  final String additionalArgs;
  SaveProviderEvent({
    this.id,
    required this.name,
    required this.url,
    required this.key,
    required this.additionalArgs,
  });
}

class DeleteProviderEvent extends SettingsEvent {
  final int providerId;
  DeleteProviderEvent(this.providerId);
}

class UpdateProviderEvent extends SettingsEvent {
  final int providerId;

  UpdateProviderEvent({required this.providerId});
}
