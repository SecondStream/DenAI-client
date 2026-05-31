part of 'chat_list_bloc.dart';

abstract class ChatsListState {}

class ChatsListInitialState extends ChatsListState {}

class ChatsListLoadingState extends ChatsListState {}

class ChatsListLoadedState extends ChatsListState {
  final List<Chat> chats;
  ChatsListLoadedState(this.chats);

  ChatsListLoadedState copyWith({List<Chat>? chats}) {
    return ChatsListLoadedState(chats ?? this.chats);
  }
}

class ChatsListErrorState extends ChatsListState {
  final ErrType errType;
  final Object error;
  ChatsListErrorState(this.errType, this.error);
}
