import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/characters_repository.dart';
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
