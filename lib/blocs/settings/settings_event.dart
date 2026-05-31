part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class LoadAllSettingsEvent extends SettingsEvent {}

class SaveSettingsEvent extends SettingsEvent {
  final SettingsBase settings;
  SaveSettingsEvent(this.settings);
}
