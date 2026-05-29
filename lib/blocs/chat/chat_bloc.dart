import 'package:chat_bot_client/application/l10n.dart';
import 'package:chat_bot_client/models/models.dart';
import 'package:chat_bot_client/repositories/characters_repository.dart';
import 'package:chat_bot_client/repositories/chats_repository.dart';
import 'package:chat_bot_client/repositories/user_cards_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatsRepository _repository;
  final CharactersRepository _charactersRepository;
  final UserCardsRepository _userCardsRepository;

  ChatBloc(this._repository, this._charactersRepository, this._userCardsRepository)
    : super(ChatInitialState()) {
    on<LoadChatHistoryEvent>(_onLoadChatHistory);
    on<SendUserMessageEvent>(_onSendUserMessage);
    on<ReceivedAiTokenEvent>(_onReceivedAiToken);
    on<CheckOrCreateVirtualChatEvent>(_onCheckOrCreateVirtualChat);
    on<RequestUserCardsForDialogEvent>(_onRequestUserCardsForDialog);
    on<ChangeUserCardEvent>(_onChangeUserCard);
    on<StartNewChatSessionEvent>(_onStartNewChatSession);
    on<SwitchMessageBranchEvent>(_onSwitchMessageBranch);
    on<RegenerateLastAiMessageEvent>(_onRegenerateMessage);
    on<EditMessageEvent>(_onEditMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
    on<UpdateChatSummaryEvent>(_onUpdateChatSummary);
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

    if (updatedMessages.last.role == "assistant") {
      updatedMessages.removeLast();
    }
    updatedMessages.add(Message(id: -2, role: "assistant", content: "", createdAt: DateTime.now()));

    emit(currentState.copyWith(messages: updatedMessages, isAiTyping: true));

    try {
      final tokenStream = await _repository.regenerateMessage(currentState.chatId);

      if (tokenStream != null) {
        await for (final token in tokenStream) {
          add(ReceivedAiTokenEvent(token));
        }
      }

      final chat = await _repository.getChatById(currentState.chatId);
      emit((state as ChatLoadedState).copyWith(messages: chat.messages, isAiTyping: false));
    } catch (e) {
      emit(ChatErrorState(ErrType.sendMessage, e));
    }
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
        final Char char = await _charactersRepository.getCharacterById(event.charId);

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
                  role: "assistant",
                  content: char.greeting,
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

    var activeChatId = currentState.chatId;
    final updatedMessages = List<Message>.from(currentState.messages);

    updatedMessages.add(
      Message(id: -1, role: "user", content: event.text, createdAt: DateTime.now()),
    );

    updatedMessages.add(Message(id: -2, role: "assistant", content: "", createdAt: DateTime.now()));

    currentState = currentState.copyWith(messages: updatedMessages, isAiTyping: true);
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
      final tokenStream = await _repository.sendMessage(currentState.chatId, event.text);

      if (tokenStream != null) {
        await for (final token in tokenStream) {
          add(ReceivedAiTokenEvent(token));
        }
      }

      final chat = await _repository.getChatById(currentState.chatId);
      emit((state as ChatLoadedState).copyWith(messages: chat.messages, isAiTyping: false));
    } catch (e) {
      emit(ChatErrorState(ErrType.sendMessage, e));
    }
  }

  void _onReceivedAiToken(ReceivedAiTokenEvent event, Emitter<ChatState> emit) {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;

    final updatedMessages = List<Message>.from(currentState.messages);
    final lastIndex = updatedMessages.length - 1;
    final lastMessage = updatedMessages[lastIndex];

    updatedMessages[lastIndex] = lastMessage.copyWith(content: lastMessage.content + event.token);
    emit(currentState.copyWith(messages: updatedMessages));
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
    final char = currentState.char;
    emit(
      ChatLoadedState(
        chatId: -99,
        char: char,
        background: char.background,
        userCard: currentState.userCard,
        summary: '',
        messages: [
          if (char.greeting.isNotEmpty)
            Message(id: -99, role: "assistant", content: char.greeting, createdAt: DateTime.now()),
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
}
