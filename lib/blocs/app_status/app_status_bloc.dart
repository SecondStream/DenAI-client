import 'package:den_ai/clients/openai_client.dart';
import 'package:den_ai/repositories/settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_status_event.dart';
part 'app_status_state.dart';

class AppStatusBloc extends Bloc<AppStatusEvent, AppStatusState> {
  final OpenAIClient _client;
  final SettingsRepository _repository;

  AppStatusBloc(this._client, this._repository) : super(AppStatusInitialState()) {
    on<AppStartedEvent>(_onAppStarted);
  }

  Future<void> _onAppStarted(AppStartedEvent event, Emitter<AppStatusState> emit) async {
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
