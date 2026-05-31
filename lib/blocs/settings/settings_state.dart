part of 'settings_bloc.dart';

abstract class SettingsState {}

class SettingsInitialState extends SettingsState {}

class SettingsLoadingState extends SettingsState {}

class SettingsErrorState extends SettingsState {
  final ErrType errType;
  final Object error;

  SettingsErrorState(this.errType, this.error);
}

class SettingsLoadedState extends SettingsState {
  final List<String> models;
  final List<String> tokenizers;
  final SettingsBase settings;

  SettingsLoadedState({required this.models, required this.tokenizers, required this.settings});

  SettingsLoadedState copyWith({
    List<String>? models,
    List<String>? tokenizers,
    SettingsBase? settings,
  }) {
    return SettingsLoadedState(
      models: models ?? this.models,
      tokenizers: tokenizers ?? this.tokenizers,
      settings: settings ?? this.settings,
    );
  }
}
