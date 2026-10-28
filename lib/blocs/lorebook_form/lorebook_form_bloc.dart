import 'dart:io';
import 'package:den_ai/blocs/notify/notify_bloc.dart';
import 'package:den_ai/repositories/lorebooks_repository.dart';
import 'package:den_ai/tools/file_tool.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';

part 'lorebook_form_event.dart';
part 'lorebook_form_state.dart';

class LorebookFormBloc extends Bloc<LorebookFormEvent, LorebookFormState> {
  final LorebooksRepository _repository;
  final NotifyBloc _notification;

  LorebookFormBloc(this._repository, this._notification) : super(LorebookFormInitialState()) {
    on<LorebookFormShownEvent>(_onShown);
    on<SubmitLorebookFormEvent>(_onSubmitForm);
    on<DeleteLorebookEvent>(_onDeleteUserCard);
  }

  void _onShown(LorebookFormShownEvent event, Emitter<LorebookFormState> emit) async {
    emit(LorebookFormLoadingState());
    try {
      final book = event.id != null ? await _repository.getLorebook(event.id!) : null;
      emit(LorebookFormSuccessState(lorebook: book));
    } catch(e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.load));
      emit(LorebookFormSuccessState());
    }
  }

  void _onSubmitForm(SubmitLorebookFormEvent event, Emitter<LorebookFormState> emit) async {
    final currentState = state;
    if (currentState is! LorebookFormSuccessState) return;

    emit(LorebookFormLoadingState());
    String? coverPath;
    if (event.coverFile != null) {
      coverPath = await FileTool.saveAvatar(event.coverFile!);
    }
    try {
      await _repository.saveLorebook(
        id: event.id,
        name: event.name,
        about: event.about,
        coverPath: coverPath,
        cropData: event.cropData,
      );
      emit(LorebookFormSaveSuccessState());
    } catch (e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.saveLorebook));
      emit(currentState.copy());
    }
  }

  void _onDeleteUserCard(DeleteLorebookEvent event, Emitter<LorebookFormState> emit) async {
    final currentState = state;
    if (currentState is! LorebookFormSuccessState) return;
    emit(LorebookFormLoadingState());
    try {
      await _repository.deleteLorebook(event.id);
      emit(LorebookFormDeleteSuccessState());
    } catch (e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.deleteLorebook));
      emit(currentState.copy());
    }
  }
}
