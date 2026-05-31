import 'package:chat_bot_client/application/l10n.dart';
import 'package:chat_bot_client/models/models.dart';
import 'package:chat_bot_client/repositories/settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc(this._repository) : super(SettingsInitialState()) {
    on<LoadAllSettingsEvent>(_onLoadAllSettings);
    on<SaveSettingsEvent>(_onSaveSettings);
  }

  void _onLoadAllSettings(LoadAllSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoadingState());
    try {
      final allSettings = await _repository.getAllSettings();
      emit(
        SettingsLoadedState(
          models: allSettings.models,
          tokenizers: allSettings.tokenizers,
          settings: allSettings.settings,
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
          tokenizers: currentState.tokenizers,
          settings: updated,
        ),
      );
    } catch (e) {
      emit(SettingsErrorState(ErrType.saveSettings, e.toString()));
    }
  }
}
