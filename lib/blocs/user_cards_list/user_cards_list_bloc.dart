import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/user_cards_repository.dart';

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
