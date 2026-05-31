part of 'chat_list_bloc.dart';

abstract class ChatsListEvent {}

class LoadAllChatsEvent extends ChatsListEvent {}

class DeleteChatEvent extends ChatsListEvent {
  final int chatId;
  DeleteChatEvent(this.chatId);
}
