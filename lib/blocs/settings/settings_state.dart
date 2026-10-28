part of 'settings_bloc.dart';

abstract class SettingsState {}

class SettingsInitialState extends SettingsState {}

class SettingsLoadingState extends SettingsState {}

class SettingsErrorState extends SettingsState {
  final ErrType errType;
  final Object error;

  SettingsErrorState(this.errType, this.error);
}

class SettingsProviderSaveSuccess extends SettingsState {
  final List<ModelInfo> models;
  final List<ModelInfo> visionModels;
  final List<ModelInfo> embeddingModels;
  final SettingsBase settings;

  SettingsProviderSaveSuccess({
    required this.models,
    required this.visionModels,
    required this.embeddingModels,
    required this.settings,
  });
}

class SettingsLoadedState extends SettingsState {
  final List<ModelInfo> models;
  final List<ModelInfo> visionModels;
  final List<ModelInfo> embeddingModels;
  final List<TokenizerInfo> tokenizers;
  final List<Provider> providers;
  final SettingsBase settings;

  SettingsLoadedState({
    required this.models,
    required this.visionModels,
    required this.embeddingModels,
    required this.tokenizers,
    required this.settings,
    required this.providers,
  });

  SettingsLoadedState copyWith({
    List<ModelInfo>? models,
    List<ModelInfo>? visionModels,
    List<ModelInfo>? embeddingModels,
    List<TokenizerInfo>? tokenizers,
    SettingsBase? settings,
    List<Provider>? providers,
  }) {
    return SettingsLoadedState(
      models: models ?? this.models.toList(),
      visionModels: models ?? this.visionModels.toList(),
      embeddingModels: embeddingModels ?? this.embeddingModels.toList(),
      tokenizers: tokenizers ?? this.tokenizers.toList(),
      settings: settings ?? this.settings,
      providers: providers ?? this.providers.toList(),
    );
  }
}

class SettingsSaveSuccess extends SettingsState {}
