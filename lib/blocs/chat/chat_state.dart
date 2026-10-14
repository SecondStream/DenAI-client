part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final int chatId;
  final Char char;
  final List<MessageView> messages;
  final String? background;
  final UserCard? userCard;
  final List<UserCard>? availableCards;
  final String summary;
  final bool isAiTyping;
  final File? selectedImageFile;

  ChatLoadedState({
    required this.chatId,
    required this.char,
    required this.messages,
    required this.summary,
    this.background,
    this.userCard,
    this.availableCards,
    this.selectedImageFile,
    this.isAiTyping = false,
  });

  ChatLoadedState copyWith({
    int? chatId,
    Char? char,
    List<MessageView>? messages,
    String? background,
    UserCard? userCard,
    String? summary,
    List<UserCard>? availableCards,
    File? selectedImageFile,
    bool? isAiTyping,
    bool isResetImage = false,
  }) {
    return ChatLoadedState(
      chatId: chatId ?? this.chatId,
      char: char ?? this.char,
      messages: messages ?? this.messages,
      background: background ?? this.background,
      summary: summary ?? this.summary,
      userCard: userCard ?? this.userCard,
      availableCards: availableCards ?? this.availableCards,
      selectedImageFile: selectedImageFile ?? (!isResetImage ? this.selectedImageFile : null),
      isAiTyping: isAiTyping ?? this.isAiTyping,
    );
  }
}

class ChatErrorState extends ChatState {
  final ErrType errType;
  final Object error;
  final String? lastUserMessage;

  ChatErrorState(this.errType, this.error, {this.lastUserMessage});
}

class MessageView extends Message {
  final int totalVariants;
  final int currentIndex;

  MessageView({
    required this.totalVariants,
    required this.currentIndex,
    required super.id,
    required super.role,
    required super.content,
    required super.createdAt,
    super.parentId,
    super.imagePath,
    super.modelName = '',
    super.isActive = true,
  });

  factory MessageView.fromMessage(Message message, int totalVariants, int currentIndex) {
    return MessageView(
      id: message.id,
      role: message.role,
      content: message.content,
      createdAt: message.createdAt,
      imagePath: message.imagePath,
      modelName: message.modelName,
      parentId: message.parentId,
      isActive: message.isActive,
      totalVariants: totalVariants,
      currentIndex: currentIndex,
    );
  }
}
