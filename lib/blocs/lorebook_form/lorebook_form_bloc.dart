import 'dart:io';
import 'package:den_ai/repositories/lorebooks_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';

part 'lorebook_form_event.dart';
part 'lorebook_form_state.dart';

class LorebookFormBloc extends Bloc<LorebookFormEvent, LorebookFormState> {
  final LorebooksRepository _repository;

  LorebookFormBloc(this._repository) : super(LorebookFormInitialState()) {
    on<SubmitLorebookFormEvent>(_onSubmitForm);
    on<DeleteLorebookEvent>(_onDeleteUserCard);
  }

  void _onSubmitForm(SubmitLorebookFormEvent event, Emitter<LorebookFormState> emit) async {
    emit(LorebookFormLoadingState());
    try {
      final saved = await _repository.saveLorebook(
        id: event.id,
        name: event.name,
        about: event.about,
        coverFile: event.coverFile,
        cropData: event.cropData,
      );
      emit(LorebookFormSuccessState(saved));
    } catch (e) {
      emit(LorebookFormErrorState(ErrType.saveLorebook, e));
    }
  }

  void _onDeleteUserCard(DeleteLorebookEvent event, Emitter<LorebookFormState> emit) async {
    emit(LorebookFormLoadingState());
    try {
      await _repository.deleteLorebook(event.id);
      emit(LorebookFormDeleteSuccessState());
    } catch (e) {
      emit(LorebookFormErrorState(ErrType.deleteLorebook, e));
    }
  }
}
