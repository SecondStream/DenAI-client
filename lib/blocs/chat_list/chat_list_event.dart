part of 'chat_list_bloc.dart';

abstract class ChatsListEvent {}

class ChatListShownEvent extends ChatsListEvent {
  final ImportedFromAssetsCardData? Function(String name) getLocalizedChar;

  ChatListShownEvent(this.getLocalizedChar);
}

class LoadAllChatsEvent extends ChatsListEvent {}

class DeleteChatEvent extends ChatsListEvent {
  final int chatId;
  DeleteChatEvent(this.chatId);
}
