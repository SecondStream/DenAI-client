part of 'user_cards_list_bloc.dart';

abstract class UserCardsListState {}

class UserCardsListInitialState extends UserCardsListState {}

class UserCardsListLoadingState extends UserCardsListState {}

class UserCardsListLoadedState extends UserCardsListState {
  final List<UserCard> cards;
  UserCardsListLoadedState(this.cards);
}

class UserCardsListErrorState extends UserCardsListState {
  final ErrType errType;
  final Object error;

  UserCardsListErrorState(this.errType, this.error);
}
