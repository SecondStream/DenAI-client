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
  final List<ModelInfo> models;
  final List<ModelInfo> visionModels;
  final List<String> tokenizers;
  final List<String> providers;
  final SettingsBase settings;

  SettingsLoadedState({
    required this.models,
    required this.visionModels,
    required this.tokenizers,
    required this.settings,
    required this.providers,
  });

  SettingsLoadedState copyWith({
    List<ModelInfo>? models,
    List<ModelInfo>? visionModels,
    List<String>? tokenizers,
    SettingsBase? settings,
    List<String>? providers,
  }) {
    return SettingsLoadedState(
      models: models ?? this.models,
      visionModels: models ?? this.visionModels,
      tokenizers: tokenizers ?? this.tokenizers,
      settings: settings ?? this.settings,
      providers: providers ?? this.providers,
    );
  }
}
