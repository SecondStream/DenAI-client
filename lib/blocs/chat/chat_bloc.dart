import 'dart:async';
import 'dart:io';

import 'package:den_ai/application/config.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/consts/consts.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/characters_repository.dart';
import 'package:den_ai/repositories/chats_repository.dart';
import 'package:den_ai/repositories/user_cards_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  static const String defUser = 'User';
  final ChatsRepository _repository;
  final CharactersRepository _charactersRepository;
  final UserCardsRepository _userCardsRepository;
  final AppConfig config;
  StreamSubscription<StreamMessage>? _messageSubscription;

  ChatBloc(this._repository, this._charactersRepository, this._userCardsRepository, this.config)
    : super(ChatInitialState()) {
    on<LoadChatHistoryEvent>(_onLoadChatHistory);
    on<SendUserMessageEvent>(_onSendUserMessage);
    on<ReceivedAiTokenEvent>(_onReceivedAiToken);
    on<ReceivedAiTokenErrorEvent>(_onReceivedAiTokenError);
    on<CheckOrCreateVirtualChatEvent>(_onCheckOrCreateVirtualChat);
    on<RequestUserCardsForDialogEvent>(_onRequestUserCardsForDialog);
    on<ChangeUserCardEvent>(_onChangeUserCard);
    on<StartNewChatSessionEvent>(_onStartNewChatSession);
    on<SwitchMessageBranchEvent>(_onSwitchMessageBranch);
    on<RegenerateLastAiMessageEvent>(_onRegenerateMessage);
    on<EditMessageEvent>(_onEditMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
    on<UpdateChatSummaryEvent>(_onUpdateChatSummary);
    on<SelectImageEvent>(_onSelectImage);

    _messageSubscription = _repository.allMessagesStream.listen(
      (message) => add(ReceivedAiTokenEvent(message)),
      onError: (e, _) {
        if (e is StreamMessageError) add(ReceivedAiTokenErrorEvent(e));
      },
      cancelOnError: false,
    );
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _messageSubscription = null;
    return super.close();
  }

  void _onLoadChatHistory(LoadChatHistoryEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    try {
      final chat = await _repository.getChatById(event.chatId);
      emit(
        ChatLoadedState(
          chatId: event.chatId,
          char: chat.char,
          messages: chat.messages,
          background: chat.background ?? chat.char.background,
          userCard: chat.userCard,
          summary: chat.summary,
        ),
      );
    } catch (e) {
      emit(ChatErrorState(ErrType.loadChat, e));
    }
  }

  void _onEditMessage(EditMessageEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;

    try {
      final updatedChat = await _repository.editMessage(event.messageId, event.newContent);
      emit(currentState.copyWith(messages: updatedChat.messages));
    } catch (e) {
      emit(ChatErrorState(ErrType.editMessage, e));
    }
  }

  void _onDeleteMessage(DeleteMessageEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;

    try {
      final Chat updatedChat = await _repository.deleteMessage(event.messageId);

      emit(currentState.copyWith(messages: updatedChat.messages));
    } catch (e) {
      emit(ChatErrorState(ErrType.removeMessage, e));
    }
  }

  void _onRegenerateMessage(RegenerateLastAiMessageEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    var currentState = state as ChatLoadedState;

    if (currentState.chatId <= 0 || currentState.messages.isEmpty) return;

    final updatedMessages = List<Message>.from(currentState.messages);

    if (updatedMessages.last.role == MessageRole.assistant) {
      updatedMessages.removeLast();
    }
    updatedMessages.add(
      Message(id: -2, role: MessageRole.assistant, content: "", createdAt: DateTime.now()),
    );

    emit(currentState.copyWith(messages: updatedMessages, isAiTyping: true));

    unawaited(_repository.regenerateMessage(currentState.chatId));
  }

  void _onSwitchMessageBranch(SwitchMessageBranchEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;
    try {
      final Chat updatedChat = await _repository.switchMessageBranch(
        event.messageId,
        event.direction,
      );

      emit(currentState.copyWith(messages: updatedChat.messages));
    } catch (e) {
      emit(ChatErrorState(ErrType.switchMessage, e));
    }
  }

  void _onCheckOrCreateVirtualChat(
    CheckOrCreateVirtualChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoadingState());

    try {
      final Chat? existingChat = await _repository.getActiveChatByCharId(event.charId);

      if (existingChat != null) {
        emit(
          ChatLoadedState(
            chatId: existingChat.id,
            char: existingChat.char,
            background: existingChat.background ?? existingChat.char.background,
            messages: existingChat.messages,
            userCard: existingChat.userCard,
            summary: existingChat.summary,
          ),
        );
      } else {
        final char = await _charactersRepository.getCharacterById(event.charId);
        if (char == null) {
          emit(ChatErrorState(ErrType.loadChat, 'Character not found'));
          return;
        }

        UserCard? defaultUserCard;
        try {
          defaultUserCard = await _userCardsRepository.getDefaultUserCard();
        } catch (_) {}

        emit(
          ChatLoadedState(
            chatId: -99,
            char: char,
            background: char.background,
            userCard: defaultUserCard,
            summary: '',
            messages: [
              if (char.greeting.isNotEmpty)
                Message(
                  id: -99,
                  role: MessageRole.assistant,
                  content: _replacePlaceholders(
                    char.greeting,
                    char.name,
                    defaultUserCard?.name ?? defUser,
                  ),
                  createdAt: DateTime.now(),
                ),
            ],
          ),
        );
      }
    } catch (e) {
      emit(ChatErrorState(ErrType.loadChat, e));
    }
  }

  void _onRequestUserCardsForDialog(
    RequestUserCardsForDialogEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatLoadedState) return;
    var currentState = state as ChatLoadedState;
    var cards = await _userCardsRepository.getUserCards();
    emit(currentState.copyWith(availableCards: cards));
  }

  void _onSendUserMessage(SendUserMessageEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    var currentState = state as ChatLoadedState;
    final imageFile = currentState.selectedImageFile;

    var activeChatId = currentState.chatId;
    final updatedMessages = List<Message>.from(currentState.messages);
    String localDisplayContent = event.text;
    String? imagePath;
    if (imageFile != null) {
      imagePath = await _repository.uploadImage(imageFile);
      if (imagePath != null) {
        final String markdownTag = MessageTags.imgTemplate.replaceFirst(
          MessageTags.urlMarker,
          "${config.baseUrl}/$imagePath",
        );

        if (localDisplayContent.contains(MessageTags.img)) {
          localDisplayContent = localDisplayContent.replaceFirst(MessageTags.img, markdownTag);
        } else {
          localDisplayContent = "$localDisplayContent\n$markdownTag";
        }
      }
    }

    final userMessage = Message(
      id: -1,
      role: MessageRole.user,
      content: localDisplayContent,
      createdAt: DateTime.now(),
      imagePath: imagePath,
    );
    updatedMessages.add(userMessage);

    updatedMessages.add(
      Message(id: -2, role: MessageRole.assistant, content: "", createdAt: DateTime.now()),
    );

    currentState = currentState.copyWith(
      messages: updatedMessages,
      isAiTyping: true,
      selectedImageFile: null,
      isResetImage: true,
    );
    emit(currentState);

    try {
      if (activeChatId <= 0) {
        final Chat newChat = await _repository.createNewChat(
          currentState.char.id,
          currentState.userCard?.id,
        );
        activeChatId = newChat.id;
        currentState = currentState.copyWith(chatId: activeChatId);
        emit(currentState);
      }

      unawaited(_repository.sendMessage(currentState.chatId, event.text, imagePath, imageFile));
    } catch (e) {
      final chat = await _repository.getChatById(currentState.chatId);
      emit(
        currentState.copyWith(
          messages: chat.messages,
          isAiTyping: false,
          selectedImageFile: imageFile,
        ),
      );
    }
  }

  void _onReceivedAiToken(ReceivedAiTokenEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;
    final message = event.message;
    if (currentState.chatId != message.chatId) return;

    if (message.status == MessageStatus.completed) {
      final chat = await _repository.getChatById(currentState.chatId);
      emit(currentState.copyWith(messages: chat.messages, isAiTyping: false));
    } else {
      final updatedMessages = List<Message>.from(currentState.messages);
      final lastIndex = updatedMessages.length - 1;
      final lastMessage = updatedMessages[lastIndex];
      if (lastMessage.id < 0) {
        updatedMessages[lastIndex] = lastMessage.copyWith(
          content: message.token,
          modelName: message.model,
        );
      } else {
        updatedMessages.add(
          Message(
            id: -2,
            role: MessageRole.assistant,
            content: message.token,
            createdAt: DateTime.now(),
            modelName: message.model,
          ),
        );
      }
      emit(currentState.copyWith(messages: updatedMessages, isAiTyping: true));
    }
  }

  void _onReceivedAiTokenError(ReceivedAiTokenErrorEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;
    final error = event.error;
    if (currentState.chatId != error.chatId) return;

    emit(ChatErrorState(ErrType.sendMessage, '', lastUserMessage: error.lastUserMessage));
    final chat = await _repository.getChatById(currentState.chatId);
    emit(
      currentState.copyWith(
        messages: chat.messages,
        isAiTyping: false,
        selectedImageFile: error.imageFile,
      ),
    );
  }

  void _onChangeUserCard(ChangeUserCardEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;
    try {
      if (currentState.chatId > 0) {
        await _repository.updateChatUserCard(currentState.chatId, event.cardId);
      }
      final card = currentState.availableCards?.firstWhere((e) => e.id == event.cardId);
      if (card != null) emit(currentState.copyWith(userCard: card));
    } catch (e) {
      emit(ChatErrorState(ErrType.updateCard, e));
    }
  }

  void _onStartNewChatSession(StartNewChatSessionEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;

    final id = currentState.chatId;
    if (event.shouldDeleteCurrent && id > 0) {
      try {
        await _repository.deleteChat(id);
        // ignore: empty_catches
      } catch (e) {}
    }
    final char = await _charactersRepository.getCharacterById(currentState.char.id);
    if (char == null) {
      emit(ChatErrorState(ErrType.loadChat, 'Character not found'));
      return;
    }
    emit(
      ChatLoadedState(
        chatId: -99,
        char: char,
        background: char.background,
        userCard: currentState.userCard,
        summary: '',
        messages: [
          if (char.greeting.isNotEmpty)
            Message(
              id: -99,
              role: MessageRole.assistant,
              content: _replacePlaceholders(
                char.greeting,
                char.name,
                currentState.userCard?.name ?? defUser,
              ),
              createdAt: DateTime.now(),
            ),
        ],
      ),
    );
  }

  void _onUpdateChatSummary(UpdateChatSummaryEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;

    if (currentState.chatId <= 0) return;

    try {
      final Chat updatedChat = await _repository.updateChatSummary(
        currentState.chatId,
        event.newSummary,
      );
      emit(currentState.copyWith(summary: updatedChat.summary));
    } catch (e) {
      emit(ChatErrorState(ErrType.saveSummary, e));
    }
  }

  void _onSelectImage(SelectImageEvent event, Emitter<ChatState> emit) {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;
    emit(currentState.copyWith(selectedImageFile: event.fileImage, isResetImage: true));
  }

  String _replacePlaceholders(String text, String charName, String userName) {
    final regex = RegExp(r'\{\{(char|user)\}\}', caseSensitive: false);

    return text.replaceAllMapped(regex, (match) {
      final tag = match.group(1)?.toLowerCase();

      if (tag == 'char') return charName;
      if (tag == 'user') return userName;

      return match.group(0) ?? '';
    });
  }
}
