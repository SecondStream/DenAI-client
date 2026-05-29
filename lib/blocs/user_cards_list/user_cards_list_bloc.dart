import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_bot_client/application/l10n.dart';
import 'package:chat_bot_client/models/models.dart';
import 'package:chat_bot_client/repositories/user_cards_repository.dart';

part 'user_cards_list_event.dart';
part 'user_cards_list_state.dart';

class UserCardsListBloc extends Bloc<UserCardsListEvent, UserCardsListState> {
  final UserCardsRepository _repository;

  UserCardsListBloc(this._repository) : super(UserCardsListInitialState()) {
    on<LoadAllUserCardsEvent>(_onLoadAllUserCards);
  }

  void _onLoadAllUserCards(LoadAllUserCardsEvent event, Emitter<UserCardsListState> emit) async {
    emit(UserCardsListLoadingState());
    try {
      final cards = await _repository.getUserCards();
      emit(UserCardsListLoadedState(cards));
    } catch (e) {
      emit(UserCardsListErrorState(ErrType.loadUserCards, e));
    }
  }
}
