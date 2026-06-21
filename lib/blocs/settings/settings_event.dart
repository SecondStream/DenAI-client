part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class LoadAllSettingsEvent extends SettingsEvent {}

class UpdateProviderEvent extends SettingsEvent {
  final String provider;

  UpdateProviderEvent({required this.provider});
}

class SaveSettingsEvent extends SettingsEvent {
  final SettingsBase settings;
  SaveSettingsEvent(this.settings);
}
