import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/blocs/notify/notify_bloc.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/characters_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final CharactersRepository _repository;
  final NotifyBloc _notification;

  CharactersBloc(this._repository, this._notification) : super(CharactersInitialState()) {
    on<LoadAllCharactersEvent>(_onLoadAllCharacters);
  }

  void _onLoadAllCharacters(LoadAllCharactersEvent event, Emitter<CharactersState> emit) async {
    emit(CharactersLoadingState());
    try {
      final characters = await _repository.getCharacters();
      characters.sort((a, b) => b.id.compareTo(a.id));
      emit(CharactersLoadedState(characters));
    } catch (e) {
      _notification.add(ErrorOccurredEvent(type: ErrType.loadCharacters));
      emit(CharactersLoadedState([]));
    }
  }
}
