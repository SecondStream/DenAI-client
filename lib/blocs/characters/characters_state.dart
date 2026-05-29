part of 'characters_bloc.dart';

abstract class CharactersState {}

class CharactersInitialState extends CharactersState {}

class CharactersLoadingState extends CharactersState {}

class CharactersLoadedState extends CharactersState {
  final List<Char> characters;
  CharactersLoadedState(this.characters);
}

class ChatCreatedRedirectState extends CharactersState {
  final int chatId;
  ChatCreatedRedirectState(this.chatId);
}

class CharactersErrorState extends CharactersState {
  final ErrType errType;
  final Object error;

  CharactersErrorState(this.errType, this.error);
}
