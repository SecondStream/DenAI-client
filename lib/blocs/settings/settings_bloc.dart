import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc(this._repository) : super(SettingsInitialState()) {
    on<LoadAllSettingsEvent>(_onLoadAllSettings);
    on<UpdateProviderEvent>(_onUpdateProvider);
    on<SaveSettingsEvent>(_onSaveSettings);
  }

  void _onUpdateProvider(UpdateProviderEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoadingState());
    try {
      final allSettings = await _repository.getFakeProviderSettings(event.provider);
      emit(
        SettingsLoadedState(
          models: allSettings.models,
          visionModels: allSettings.visionModels,
          tokenizers: allSettings.tokenizers,
          settings: allSettings.settings,
          providers: allSettings.providers,
        ),
      );
    } catch (e) {
      emit(SettingsErrorState(ErrType.loadSettings, e.toString()));
    }
  }

  void _onLoadAllSettings(LoadAllSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoadingState());
    try {
      final allSettings = await _repository.getAllSettings();
      emit(
        SettingsLoadedState(
          models: allSettings.models,
          visionModels: allSettings.visionModels,
          tokenizers: allSettings.tokenizers,
          settings: allSettings.settings,
          providers: allSettings.providers,
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
      final updated = await _repository.updateSettings(event.settings);
      emit(
        SettingsLoadedState(
          models: currentState.models,
          visionModels: currentState.visionModels,
          tokenizers: currentState.tokenizers,
          settings: updated,
          providers: currentState.providers,
        ),
      );
    } catch (e) {
      emit(SettingsErrorState(ErrType.saveSettings, e.toString()));
    }
  }
}
