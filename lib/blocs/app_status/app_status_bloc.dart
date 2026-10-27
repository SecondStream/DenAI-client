import 'dart:async';

import 'package:den_ai/clients/openai_client.dart';
import 'package:den_ai/repositories/settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_status_event.dart';
part 'app_status_state.dart';

class AppStatusBloc extends Bloc<AppStatusEvent, AppStatusState> {
  final OpenAIClient _client;
  final SettingsRepository _repository;

  AppStatusBloc(this._client, this._repository) : super(AppStatusInitialState()) {
    on<AppStartedEvent>(_onStatusChecked);
    on<StatusCheckedEvent>(_onStatusChecked);
    on<ProviderChangedEvent>(_onProviderChanged);
  }

  Future<void> _onStatusChecked(AppStatusEvent event, Emitter<AppStatusState> emit) async {
    await _checkStatus(emit);
  }

  FutureOr<void> _onProviderChanged(ProviderChangedEvent event, Emitter<AppStatusState> emit) async {
    if (event.modelsLoadedSuccess) {
      await _checkStatus(emit);
    } else {
      emit(
        AppStatusSuccessState(
          chatModelAvailable: false,
          embeddingModelAvailable: false,
          visionModelAvailable: false,
          providerAvailable: false,
        ),
      );
    }
  }

  Future<void> _checkStatus(Emitter<AppStatusState> emit) async {
    emit(AppStatusLoadingState());
    try {
      final settings = await _repository.getSettings();
      final models = await _client.fetchAllModelNames(settings);
      emit(
        AppStatusSuccessState(
          chatModelAvailable: models.contains(settings.modelName),
          embeddingModelAvailable: models.contains(settings.embeddingModelName),
          visionModelAvailable: models.contains(settings.visionModelName),
          providerAvailable: true,
        ),
      );
    } catch (e) {
      emit(
        AppStatusSuccessState(
          chatModelAvailable: false,
          embeddingModelAvailable: false,
          visionModelAvailable: false,
          providerAvailable: false,
        ),
      );
    }
  }
}
