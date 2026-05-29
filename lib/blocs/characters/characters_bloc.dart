import 'package:chat_bot_client/application/l10n.dart';
import 'package:chat_bot_client/models/models.dart';
import 'package:chat_bot_client/repositories/characters_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final CharactersRepository _repository;

  CharactersBloc(this._repository) : super(CharactersInitialState()) {
    on<LoadAllCharactersEvent>(_onLoadAllCharacters);
  }

  void _onLoadAllCharacters(LoadAllCharactersEvent event, Emitter<CharactersState> emit) async {
    emit(CharactersLoadingState());
    try {
      final characters = await _repository.getCharacters();
      emit(CharactersLoadedState(characters));
    } catch (e) {
      emit(CharactersErrorState(ErrType.loadCharacters, e));
    }
  }
}
