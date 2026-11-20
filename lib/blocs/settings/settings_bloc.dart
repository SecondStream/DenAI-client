import 'dart:async';
import 'dart:io';

import 'package:den_ai/application/env.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/application/logger.dart';
import 'package:den_ai/blocs/app_status/app_status_bloc.dart';
import 'package:den_ai/blocs/notify/notify_bloc.dart';
import 'package:den_ai/clients/openai_client.dart';
import 'package:den_ai/consts/consts.dart';
import 'package:den_ai/managers/lore_vector_storage.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/lorebooks_repository.dart';
import 'package:den_ai/repositories/settings_repository.dart';
import 'package:den_ai/screens/settings_screen.dart';
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
    on<TokenizerUploadedEvent>(_onTokenizerUploaded);
  }

  void _onLoadAllSettings(LoadAllSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoadingState());
    try {
      final settings = await _repository.getSettings();
      final providers = await _repository.getAllProviders();
      final (models, visionModels, embeddingModels, success) = await _getModels(settings);
      final tokenizers = await getAvailableTokenizers();
      final activeModes = await _repository.getActiveModels(settings);
      emit(
        SettingsLoadedState(
          models: models,
          visionModels: visionModels,
          embeddingModels: embeddingModels,
          tokenizers: tokenizers,
          settings: settings,
          providers: providers,
          activeModels: activeModes,
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
      final oldSettings = await _repository.getSettings();
      final models = await _repository.getActiveModels(oldSettings);
      final providerId = oldSettings.provider.id; // TODO: Different providers

      if (models.embedding.name != event.modelEmbedding.name) {
        await _rebuildAllEmbeddings(
          event.settings,
          models.embedding.copyWith(name: event.modelEmbedding.name),
        );
        _repository.updateModel(ModelType.embedding, event.modelEmbedding.name, providerId, false);
      }

      await _repository.saveSettings(event.settings);

      if (models.chat.name != event.model.name) {
        await _repository.updateModel(
          ModelType.chat,
          event.model.name,
          providerId,
          event.model.handInputName,
        );
      }

      if (models.vision.name != event.modelVision.name) {
        await _repository.updateModel(
          ModelType.vision,
          event.modelVision.name,
          providerId,
          event.modelVision.handInputName,
        );
      }

      statusBloc.add(StatusCheckedEvent());
      emit(SettingsSaveSuccess());
    } catch (e, st) {
      _notification.add(ErrorOccurredEvent(type: ErrType.saveSettings, error: e, stackTrace: st));
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
    } catch (e, st) {
      AppLogger.error('getAvailableTokenizers', error: e, stackTrace: st);
    }

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
    } catch (e, st) {
      AppLogger.error('getAvailableTokenizers custom', error: e, stackTrace: st);
    }

    return tokenizers;
  }

  void _onUpdateProvider(UpdateProviderEvent event, Emitter<SettingsState> emit) async {
    if (state is! SettingsLoadedState) return;
    final currentState = state as SettingsLoadedState;
    emit(SettingsLoadingState());
    try {
      await _repository.updateActiveProviderId(event.providerId);
      await _toSaveSuccessProvider(currentState, emit);
    } catch (e, st) {
      _notification.add(ErrorOccurredEvent(type: ErrType.loadSettings, error: e, stackTrace: st));
      emit(currentState.copyWith());
    }
  }

  FutureOr<void> _onSaveProvider(SaveProviderEvent event, Emitter<SettingsState> emit) async {
    if (state is! SettingsLoadedState) return;
    final currentState = state as SettingsLoadedState;
    emit(SettingsLoadingState());

    try {
      await _repository.saveProvider(
        id: event.id,
        name: event.name,
        url: event.url,
        key: event.key,
        additionalArgs: event.additionalArgs,
      );
      await _toSaveSuccessProvider(currentState, emit);
    } catch (e, st) {
      _notification.add(ErrorOccurredEvent(type: ErrType.save, error: e, stackTrace: st));
      emit(currentState.copyWith());
    }
  }

  FutureOr<void> _onDeleteProvider(DeleteProviderEvent event, Emitter<SettingsState> emit) async {
    if (state is! SettingsLoadedState) return;
    final currentState = state as SettingsLoadedState;
    emit(SettingsLoadingState());

    try {
      await _repository.deleteProvider(event.providerId);
      await _toSaveSuccessProvider(currentState, emit);
    } catch (e, st) {
      _notification.add(ErrorOccurredEvent(type: ErrType.remove, error: e, stackTrace: st));
      emit(currentState.copyWith());
    }
  }

  Future<void> _toSaveSuccessProvider(
    SettingsLoadedState currentState,
    Emitter<SettingsState> emit,
  ) async {
    final settings = await _repository.getSettings();
    final activeModels = await _repository.clearModels(settings);
    _client.clearCache();
    final (models, visionModels, embeddingModels, code) = await _getModels(settings);
    emit(
      SettingsProviderSaveSuccess(
        models: models,
        visionModels: visionModels,
        embeddingModels: embeddingModels,
        settings: settings,
        activeModels: activeModels,
      ),
    );
    statusBloc.add(ProviderChangedEvent(code));
    final providers = await _repository.getAllProviders();
    emit(
      currentState.copyWith(
        models: models,
        visionModels: visionModels,
        embeddingModels: embeddingModels,
        settings: settings,
        providers: providers,
        activeModels: activeModels,
      ),
    );
  }

  Future<(List<ModelInfo>, List<ModelInfo>, List<ModelInfo>, int)> _getModels(
    SettingsBase settings,
  ) async {
    final (models, code) = await _client.fetchModels(
      settings.provider,
    ); // TODO: Different providers
    final (visionModels, _) = code == Consts.normalCode
        ? await _client.fetchVisionModels(settings.provider)
        : (<ModelInfo>[], false);
    final (embeddingModels, _) = code == Consts.normalCode
        ? await _client.fetchEmbeddingModels(settings.provider)
        : (<ModelInfo>[], false);
    return (models, visionModels, embeddingModels, code);
  }

  Future<void> _rebuildAllEmbeddings(SettingsBase settings, Model model) async {
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
                model: model,
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

  Future<void> _onTokenizerUploaded(TokenizerUploadedEvent event, Emitter<SettingsState> emit) async {
    final currentState = state;
    if (currentState is! SettingsLoadedState) return;
    final tokenizers = await getAvailableTokenizers();
    emit(currentState.copyWith(tokenizers: tokenizers));
  }
}

class _BatchResult {
  final int lorebookId;
  final List<List<double>> embeddings;
  _BatchResult(this.lorebookId, this.embeddings);
}
