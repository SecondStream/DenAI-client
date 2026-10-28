import 'dart:async';
import 'dart:io';

import 'package:den_ai/application/env.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/blocs/app_status/app_status_bloc.dart';
import 'package:den_ai/blocs/notify/notify_bloc.dart';
import 'package:den_ai/clients/openai_client.dart';
import 'package:den_ai/managers/lore_vector_storage.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/lorebooks_repository.dart';
import 'package:den_ai/repositories/settings_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;
  final LorebooksRepository _lorebooksRepository;
  final LoreVectorStorage _storage;
  final OpenAIClient _client;
  final AppStatusBloc statusBloc;
  final NotifyBloc _notification;

  SettingsBloc(
    this._repository,
    this._lorebooksRepository,
    this._client,
    this._storage,
    this.statusBloc,
      this._notification,
  ) : super(SettingsInitialState()) {
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
      final (models, visionModels, embeddingModels, success) = await _getModels(settings);
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
    final currentState = state;
    if (currentState is! SettingsLoadedState) return;
    emit(SettingsLoadingState());
    try {
      final settings = await _repository.getSettings();
      if (settings.embeddingModelName != event.settings.embeddingModelName) {
        await _rebuildAllEmbeddings(event.settings);
      }
      await _repository.saveSettings(event.settings);
      statusBloc.add(StatusCheckedEvent());
      emit(SettingsSaveSuccess());
    } catch (e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.saveSettings));
      emit(currentState.copyWith());
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
      final (models, visionModels, embeddingModels, success) = await _getModels(settings);
      emit(
        SettingsProviderSaveSuccess(
          models: models,
          visionModels: visionModels,
          embeddingModels: embeddingModels,
          settings: settings,
        ),
      );
      statusBloc.add(ProviderChangedEvent(success));
      emit(
        currentState.copyWith(
          models: models,
          visionModels: visionModels,
          embeddingModels: embeddingModels,
          settings: settings,
        ),
      );
    } catch (e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.loadSettings));
      emit(currentState.copyWith());
    }
  }

  FutureOr<void> _onSaveProvider(SaveProviderEvent event, Emitter<SettingsState> emit) async {
    if (state is! SettingsLoadedState) return;
    final currentState = state as SettingsLoadedState;
    emit(SettingsLoadingState());

    try {
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
        final (models, visionModels, embeddingModels, success) = await _getModels(settings);
        emit(
          SettingsProviderSaveSuccess(
            models: models,
            visionModels: visionModels,
            embeddingModels: embeddingModels,
            settings: settings,
          ),
        );
        statusBloc.add(ProviderChangedEvent(success));
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
    } catch (e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.save));
      emit(currentState.copyWith());
    }
  }

  FutureOr<void> _onDeleteProvider(DeleteProviderEvent event, Emitter<SettingsState> emit) async {
    if (state is! SettingsLoadedState) return;
    final currentState = state as SettingsLoadedState;
    emit(SettingsLoadingState());

    try {
      await _repository.deleteProvider(event.providerId);
      final settings = await _repository.getSettings();
      _client.clearCache();
      final (models, visionModels, embeddingModels, success) = await _getModels(settings);
      emit(
        SettingsProviderSaveSuccess(
          models: models,
          visionModels: visionModels,
          embeddingModels: embeddingModels,
          settings: settings,
        ),
      );
      statusBloc.add(ProviderChangedEvent(success));
      emit(
        currentState.copyWith(
          models: models,
          visionModels: visionModels,
          embeddingModels: embeddingModels,
          settings: settings,
          providers: await _repository.getAllProviders(),
        ),
      );
    } catch (e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.remove));
      emit(currentState.copyWith());
    }
  }

  Future<(List<ModelInfo>, List<ModelInfo>, List<ModelInfo>, bool)> _getModels(
    SettingsBase settings,
  ) async {
    final (models, success) = await _client.fetchModels(settings);
    final (visionModels, _) = success
        ? await _client.fetchVisionModels(settings)
        : ([ModelInfo(name: _client.defaultVisionModel, info: "???")], false);
    final (embeddingModels, _) = success
        ? await _client.fetchEmbeddingModels(settings)
        : ([ModelInfo(name: _client.defaultEmbeddingModel, info: "???")], false);
    return (models, visionModels, embeddingModels, success);
  }

  Future<void> _rebuildAllEmbeddings(SettingsBase settings) async {
    var delay = 2;
    final retryDelay = 15;

    final List<Lorebook> lorebooks = await _lorebooksRepository.getAllFullLorebooks();
    if (lorebooks.isEmpty) return;

    final Map<int, List<List<double>>> memoryCache = {};

    for (int i = 0; i < lorebooks.length; i += 2) {
      final int endIndex = (i + 2 > lorebooks.length) ? lorebooks.length : i + 2;
      final List<Lorebook> batch = lorebooks.sublist(i, endIndex);
      int retryCount = 0;
      const int maxRetries = 3;
      bool isBatchSuccess = false;

      while (!isBatchSuccess) {
        try {
          final results = await Future.wait(
            batch.map((lorebook) async {
              final List<String> texts = lorebook.getEntriesTexts();
              if (texts.isEmpty) return null;

              final List<List<double>> embeddings = await _client.getEmbeddings(
                texts: texts,
                settings: settings,
              );

              return _BatchResult(lorebook.id, embeddings);
            }),
          );

          for (final res in results) {
            if (res != null) {
              memoryCache[res.lorebookId] = res.embeddings;
            }
          }

          isBatchSuccess = true;
        } catch (e) {
          retryCount++;
          if (retryCount >= maxRetries) {
            rethrow;
          }

          delay += 3;
          await Future.delayed(Duration(seconds: retryDelay));
        }
      }
      if (endIndex < lorebooks.length) {
        await Future.delayed(Duration(seconds: delay));
      }
    }

    for (final entry in memoryCache.entries) {
      await _storage.saveVectors(entry.key, entry.value);
    }
  }
}

class _BatchResult {
  final int lorebookId;
  final List<List<double>> embeddings;
  _BatchResult(this.lorebookId, this.embeddings);
}
