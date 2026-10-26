import 'dart:async';
import 'dart:io';

import 'package:den_ai/application/env.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/clients/openai_client.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/settings_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;
  final OpenAIClient _client;

  SettingsBloc(this._repository, this._client) : super(SettingsInitialState()) {
    on<LoadAllSettingsEvent>(_onLoadAllSettings);
    on<UpdateProviderEvent>(_onUpdateProvider);
    on<SaveProviderEvent>(_onSaveProvider);
    on<DeleteProviderEvent>(_onDeleteProvider);
    on<SaveSettingsEvent>(_onSaveSettings);
  }

  void _onLoadAllSettings(LoadAllSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoadingState());
    try {
      final settings = await _repository.getSettings();
      final providers = await _repository.getAllProviders();
      final models = await _client.fetchModels(settings);
      final visionModels = await _client.fetchVisionModels(settings);
      final embeddingModels = await _client.fetchEmbeddingModels(settings);
      final tokenizers = await getAvailableTokenizers();
      emit(
        SettingsLoadedState(
          models: models,
          visionModels: visionModels,
          embeddingModels: embeddingModels,
          tokenizers: tokenizers,
          settings: settings,
          providers: providers,
        ),
      );
    } catch (e) {
      emit(SettingsErrorState(ErrType.loadSettings, e.toString()));
    }
  }

  void _onSaveSettings(SaveSettingsEvent event, Emitter<SettingsState> emit) async {
    if (state is! SettingsLoadedState) return;
    final currentState = state as SettingsLoadedState;

    emit(SettingsLoadingState());
    try {
      final updated = await _repository.saveSettings(event.settings);
      emit(
        SettingsLoadedState(
          models: currentState.models,
          visionModels: currentState.visionModels,
          embeddingModels: currentState.embeddingModels,
          tokenizers: currentState.tokenizers,
          settings: updated,
          providers: currentState.providers,
        ),
      );
    } catch (e) {
      emit(SettingsErrorState(ErrType.saveSettings, e.toString()));
    }
  }

  Future<List<TokenizerInfo>> getAvailableTokenizers() async {
    final List<TokenizerInfo> tokenizers = <TokenizerInfo>[];

    try {
      final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final assetPaths = manifest.listAssets().where(
        (path) => path.startsWith('assets/tokenizers/') && path.endsWith('.json'),
      );

      for (final assetPath in assetPaths) {
        final fileNameWithoutExtension = p.basenameWithoutExtension(assetPath);
        String displayName;

        if (fileNameWithoutExtension == 'cl100k_base') {
          displayName = 'OpenAI / Anthropic (cl100k)';
        } else {
          displayName = fileNameWithoutExtension
              .replaceAll(RegExp(r'[-_]'), ' ')
              .split(' ')
              .where((word) => word.isNotEmpty)
              .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
              .join(' ');
        }

        tokenizers.add(TokenizerInfo(id: assetPath, displayName: displayName));
      }
    } catch (_) {}

    try {
      final Directory customTokenizersDir = Directory(AppEnv.tokenizersDir);
      if (!await customTokenizersDir.exists()) {
        await customTokenizersDir.create(recursive: true);
      } else {
        final List<FileSystemEntity> entities = customTokenizersDir.listSync();
        for (final entity in entities) {
          if (entity is File && p.extension(entity.path).toLowerCase() == '.json') {
            final String fileName = p.basename(entity.path);
            tokenizers.add(TokenizerInfo(id: entity.path, displayName: fileName));
          }
        }
      }
    } catch (_) {}

    return tokenizers;
  }

  void _onUpdateProvider(UpdateProviderEvent event, Emitter<SettingsState> emit) async {
    if (state is! SettingsLoadedState) return;
    final currentState = state as SettingsLoadedState;
    emit(SettingsLoadingState());
    try {
      final settings = await _repository.updateActiveProviderId(event.providerId);
      _client.clearCache();
      final models = await _client.fetchModels(settings);
      final visionModels = await _client.fetchVisionModels(settings);
      final embeddingModels = await _client.fetchEmbeddingModels(settings);
      emit(
        currentState.copyWith(
          models: models,
          visionModels: visionModels,
          embeddingModels: embeddingModels,
          settings: settings,
        ),
      );
    } catch (e) {
      emit(SettingsErrorState(ErrType.loadSettings, e.toString()));
    }
  }

  FutureOr<void> _onSaveProvider(SaveProviderEvent event, Emitter<SettingsState> emit) async {
    if (state is! SettingsLoadedState) return;
    final currentState = state as SettingsLoadedState;
    emit(SettingsLoadingState());
    final provider = await _repository.saveProvider(
      id: event.id,
      name: event.name,
      url: event.url,
      key: event.key,
      additionalArgs: event.additionalArgs,
    );
    if (event.id == null) {
      final settings = await _repository.updateActiveProviderId(provider.id);
      _client.clearCache();
      final models = await _client.fetchModels(settings);
      final visionModels = await _client.fetchVisionModels(settings);
      final embeddingModels = await _client.fetchEmbeddingModels(settings);
      emit(
        currentState.copyWith(
          models: models,
          visionModels: visionModels,
          embeddingModels: embeddingModels,
          settings: settings,
          providers: await _repository.getAllProviders(),
        ),
      );
    } else {
      emit(currentState.copyWith(providers: await _repository.getAllProviders()));
    }
  }

  FutureOr<void> _onDeleteProvider(DeleteProviderEvent event, Emitter<SettingsState> emit) async {
    if (state is! SettingsLoadedState) return;
    final currentState = state as SettingsLoadedState;
    emit(SettingsLoadingState());
    await _repository.deleteProvider(event.providerId);
    final settings = await _repository.getSettings();
    _client.clearCache();
    final models = await _client.fetchModels(settings);
    final visionModels = await _client.fetchVisionModels(settings);
    final embeddingModels = await _client.fetchEmbeddingModels(settings);
    emit(
      currentState.copyWith(
        models: models,
        visionModels: visionModels,
        embeddingModels: embeddingModels,
        settings: settings,
        providers: await _repository.getAllProviders(),
      ),
    );
  }
}
