import 'package:den_ai/models/user_card.dart';
import 'package:den_ai/repositories/user_cards_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'drawer_event.dart';
part 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  final UserCardsRepository _repository;

  DrawerBloc(this._repository) : super(DrawerInitialState()) {
    on<DrawerShownEvent>(_onShown);
  }

  void _onShown(DrawerShownEvent event, Emitter<DrawerState> emit) async {
    final card = await _repository.getDefaultUserCard();
    emit(DrawerLoadSuccessState(card));
  }
}
