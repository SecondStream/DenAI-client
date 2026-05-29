part of 'user_card_form_bloc.dart';

abstract class UserCardFormState {}

class UserCardFormInitialState extends UserCardFormState {}

class UserCardFormLoadingState extends UserCardFormState {}

class UserCardFormSuccessState extends UserCardFormState {
  final UserCard card;
  UserCardFormSuccessState(this.card);
}

class UserCardFormErrorState extends UserCardFormState {
  final ErrType errType;
  final Object error;

  UserCardFormErrorState(this.errType, this.error);
}

class UserCardFormDeleteSuccessState extends UserCardFormState {}
