import 'dart:async';
import 'dart:io';
import 'package:den_ai/blocs/notify/notify_bloc.dart';
import 'package:den_ai/tools/file_tool.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/user_cards_repository.dart';

part 'user_card_form_event.dart';
part 'user_card_form_state.dart';

class UserCardFormBloc extends Bloc<UserCardFormEvent, UserCardFormState> {
  final UserCardsRepository _repository;
  final NotifyBloc _notification;

  UserCardFormBloc(this._repository, this._notification) : super(UserCardFormInitialState()) {
    on<ShownUserCardEvent>(_onShown);
    on<SubmitUserCardFormEvent>(_onSubmitForm);
    on<DeleteUserCardEvent>(_onDeleteUserCard);
  }

  Future<void> _onShown(ShownUserCardEvent event, Emitter<UserCardFormState> emit) async {
    emit(UserCardFormLoadingState());
    try {
      final userCard = event.id != null ? await _repository.getUserCard(event.id!) : null;
      emit(UserCardFormSuccessState(userCard));
    } catch (e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.load));
      emit(UserCardFormSuccessState(null));
    }
  }

  void _onSubmitForm(SubmitUserCardFormEvent event, Emitter<UserCardFormState> emit) async {
    final currentState = state;
    if (currentState is! UserCardFormSuccessState) return;
    emit(UserCardFormLoadingState());

    try {
      String? avatarPath;
      if (event.avatarFile != null) {
        avatarPath = await FileTool.saveAvatar(event.avatarFile!);
      }

      await _repository.saveUserCard(
        id: event.id,
        name: event.name,
        description: event.description,
        isDefault: event.isDefault,
        avatarPath: avatarPath,
        cropData: event.cropData,
      );
      emit(UserCardFormSaveSuccessState());
    } catch (e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.saveUserCard));
      emit(currentState.copy());
    }
  }

  void _onDeleteUserCard(DeleteUserCardEvent event, Emitter<UserCardFormState> emit) async {
    final currentState = state;
    if (currentState is! UserCardFormSuccessState) return;
    emit(UserCardFormLoadingState());
    try {
      await _repository.deleteUserCard(event.id);
      emit(UserCardFormDeleteSuccessState());
    } catch (e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.remove));
      emit(currentState.copy());
    }
  }
}
