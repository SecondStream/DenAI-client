import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/user_cards_repository.dart';

part 'user_card_form_event.dart';
part 'user_card_form_state.dart';

class UserCardFormBloc extends Bloc<UserCardFormEvent, UserCardFormState> {
  final UserCardsRepository _repository;

  UserCardFormBloc(this._repository) : super(UserCardFormInitialState()) {
    on<SubmitUserCardFormEvent>(_onSubmitForm);
    on<DeleteUserCardEvent>(_onDeleteUserCard);
  }

  void _onSubmitForm(SubmitUserCardFormEvent event, Emitter<UserCardFormState> emit) async {
    emit(UserCardFormLoadingState());
    try {
      final savedCard = await _repository.saveUserCard(
        id: event.id,
        name: event.name,
        description: event.description,
        isDefault: event.isDefault,
        avatarFile: event.avatarFile,
        cropData: event.cropData,
      );
      emit(UserCardFormSuccessState(savedCard));
    } catch (e) {
      emit(UserCardFormErrorState(ErrType.saveUserCard, e));
    }
  }

  void _onDeleteUserCard(DeleteUserCardEvent event, Emitter<UserCardFormState> emit) async {
    emit(UserCardFormLoadingState());
    try {
      await _repository.deleteUserCard(event.id);
      emit(UserCardFormDeleteSuccessState());
    } catch (e) {
      emit(UserCardFormErrorState(ErrType.saveCharacter, e));
    }
  }
}
