part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final int chatId;
  final Char char;
  final List<Message> messages;
  final String? background;
  final UserCard? userCard;
  final List<UserCard>? availableCards;
  final String summary;
  final bool isAiTyping;

  ChatLoadedState({
    required this.chatId,
    required this.char,
    required this.messages,
    required this.summary,
    this.background,
    this.userCard,
    this.availableCards,
    this.isAiTyping = false,
  });

  ChatLoadedState copyWith({
    int? chatId,
    List<Message>? messages,
    String? background,
    UserCard? userCard,
    String? summary,
    List<UserCard>? availableCards,
    bool? isAiTyping,
  }) {
    return ChatLoadedState(
      chatId: chatId ?? this.chatId,
      char: char,
      messages: messages ?? this.messages,
      background: background ?? this.background,
      summary: summary ?? this.summary,
      userCard: userCard ?? this.userCard,
      availableCards: availableCards ?? this.availableCards,
      isAiTyping: isAiTyping ?? this.isAiTyping,
    );
  }
}

class ChatErrorState extends ChatState {
  final ErrType errType;
  final Object error;

  ChatErrorState(this.errType, this.error);
}
