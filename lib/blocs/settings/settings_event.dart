part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class LoadAllSettingsEvent extends SettingsEvent {}

class SaveSettingsEvent extends SettingsEvent {
  final SettingsBase settings;
  SaveSettingsEvent(this.settings);
}

class SaveProviderEvent extends SettingsEvent {
  final int? id;
  final String name;
  final String url;
  final String key;
  SaveProviderEvent({this.id, required this.name, required this.url, required this.key});
}

class DeleteProviderEvent extends SettingsEvent {
  final int providerId;
  DeleteProviderEvent(this.providerId);
}

class UpdateProviderEvent extends SettingsEvent {
  final int providerId;

  UpdateProviderEvent({required this.providerId});
}
