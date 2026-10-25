import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/clients/openai_client.dart';
import 'package:den_ai/consts/consts.dart';
import 'package:den_ai/managers/lore_vector_storage.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/characters_repository.dart';
import 'package:den_ai/repositories/chats_repository.dart';
import 'package:den_ai/repositories/settings_repository.dart';
import 'package:den_ai/repositories/user_cards_repository.dart';
import 'package:den_ai/services/chat_generation_service.dart';
import 'package:den_ai/services/lore_search_service.dart';
import 'package:den_ai/services/token_counter_service.dart';
import 'package:den_ai/tools/file_tool.dart';
import 'package:den_ai/tools/prompt_renderer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  static const String defUser = 'User';
  final ChatGenerationService _generationService;
  final TokenCounterService _tokenCounterService;
  final LoreSearchService _loreSearchService;
  final LoreVectorStorage _loreVectorStorage;
  final OpenAIClient _client;
  final ChatsRepository _repository;
  final SettingsRepository _settingsRepository;
  final CharactersRepository _charactersRepository;
  final UserCardsRepository _userCardsRepository;
  StreamSubscription<StreamMessage>? _messageSubscription;

  final Map<int, List<List<double>>> _loreVectors = {};

  ChatBloc(
    this._client,
    this._generationService,
    this._tokenCounterService,
    this._loreSearchService,
    this._loreVectorStorage,
    this._repository,
    this._settingsRepository,
    this._charactersRepository,
    this._userCardsRepository,
  ) : super(ChatInitialState()) {
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
    on<UpdateCharacterEvent>(_onUpdateCharacter);

    _messageSubscription = _generationService.allMessagesStream.listen(
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
          messages: _getChatActiveMV(chat.messages),
          background: chat.background ?? chat.char.background,
          userCard: chat.userCard,
          summary: chat.summaries.lastOrNull?.content ?? '',
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
      emit(currentState.copyWith(messages: _getChatActiveMV(updatedChat.messages)));
    } catch (e) {
      emit(ChatErrorState(ErrType.editMessage, e));
    }
  }

  void _onDeleteMessage(DeleteMessageEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;

    try {
      final Chat updatedChat = await _repository.deleteMessage(event.messageId);

      emit(currentState.copyWith(messages: _getChatActiveMV(updatedChat.messages)));
    } catch (e) {
      emit(ChatErrorState(ErrType.removeMessage, e));
    }
  }

  void _onRegenerateMessage(RegenerateLastAiMessageEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    var currentState = state as ChatLoadedState;

    if (currentState.chatId <= 0 || currentState.messages.isEmpty) return;

    final updatedMessages = List<Message>.from(currentState.messages);

    updatedMessages.removeWhere((e) => e.id == event.messageId);
    updatedMessages.add(
      Message(id: -2, role: MessageRole.assistant, content: "", createdAt: DateTime.now()),
    );

    emit(currentState.copyWith(messages: _getChatActiveMV(updatedMessages), isAiTyping: true));

    _regenerateMessage(
      currentState.chatId,
      event.messageId,
      await _settingsRepository.getSettings(),
    );
  }

  void _onSwitchMessageBranch(SwitchMessageBranchEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;
    try {
      final Chat updatedChat = await _repository.switchMessageBranch(
        event.messageId,
        event.direction,
      );

      emit(currentState.copyWith(messages: _getChatActiveMV(updatedChat.messages)));
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
            messages: _getChatActiveMV(existingChat.messages),
            userCard: existingChat.userCard,
            summary: existingChat.summaries.lastOrNull?.content ?? '',
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
                MessageView.fromMessage(
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
                  1,
                  1,
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
    final settings = await _settingsRepository.getSettings();
    final imageFile = currentState.selectedImageFile;

    var activeChatId = currentState.chatId;
    final updatedMessages = List<Message>.from(currentState.messages);
    String localDisplayContent = event.text;
    String? imagePath;
    if (imageFile != null) {
      imagePath = await FileTool.saveAttachment(imageFile);

      final String markdownTag = MessageTags.imgTemplate.replaceFirst(
        MessageTags.urlMarker,
        imagePath,
      );

      if (localDisplayContent.contains(MessageTags.img)) {
        localDisplayContent = localDisplayContent.replaceFirst(MessageTags.img, markdownTag);
      } else {
        localDisplayContent = "$localDisplayContent\n$markdownTag";
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
      messages: _getChatActiveMV(updatedMessages),
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

      _sendMessage(currentState.chatId, event.text, settings, imageFile, imagePath: imagePath);
    } catch (e) {
      final chat = await _repository.getChatById(currentState.chatId);
      emit(
        currentState.copyWith(
          messages: _getChatActiveMV(chat.messages),
          isAiTyping: false,
          selectedImageFile: imageFile,
        ),
      );
    }
  }

  Future<void> _sendMessage(
    int chatId,
    String text,
    SettingsBase settings,
    File? imageFile, {
    String? imagePath,
  }) async {
    if (imageFile != null) {
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      final imageDescription =
          '${MessageTags.imgXmlStart}${await _client.describeImage(base64Image: base64Image, prompt: DefaultSettings.describeImagePrompt, settings: settings)}${MessageTags.imgXmlEnd}';
      if (text.contains(MessageTags.img)) {
        text = text.replaceAll(MessageTags.img, imageDescription);
      } else {
        text += '\n$imageDescription';
      }
    }
    final userMessageId = await _repository.insertMessage(
      chatId: chatId,
      role: MessageRole.user,
      content: text,
      imagePath: imagePath,
    );
    final chat = await _repository.getChatById(chatId);
    final String? latestSummaryContent =
        chat.summaries.isNotEmpty && chat.summaries.last.content.trim().isNotEmpty
        ? chat.summaries.last.content.trim()
        : null;
    final systemContent = PromptRenderer.getSystemContent(
      settings: settings,
      chat: chat,
      summary: latestSummaryContent,
    );

    final messages = await _getMessages(chat, systemContent, settings, text);

    return _generationService.requestAiResponse(
      chatId: chat.id,
      charId: chat.char.id,
      settings: settings,
      formattedMessages: messages,
      isNew: true,
      parentId: userMessageId,
      lastActiveMsgId: null,
      lastUserTextForError: text,
      lastUserImageForError: imageFile,
    );
  }

  Future<Map<String, String>?> _getLoreMessage(
    Chat chat,
    SettingsBase settings,
    String text,
  ) async {
    try {
      final lorebooks = chat.char.lorebooks;
      if (lorebooks.isNotEmpty && text.length >= DefaultSettings.minLenForLore) {
        String? loreContent;
        final queryVectors = await _client.getEmbeddings(texts: [text], settings: settings);
        final queryVector = queryVectors[0];
        if (queryVector.isNotEmpty) {
          for (final book in lorebooks) {
            if (!_loreVectors.containsKey(book.id)) {
              _loreVectors[book.id] = await _loreVectorStorage.loadVectors(book.id);
            }
            final vectors = _loreVectors[book.id]!;
            if (vectors.isNotEmpty) {
              final searchRes = _loreSearchService.findRelevantLore(
                userInput: text,
                entriesText: book.getEntriesTexts(),
                allVectors: vectors,
                queryVector: queryVector,
              );

              if (searchRes.isNotEmpty) {
                loreContent = loreContent == null ? searchRes : '$loreContent\n\n$searchRes';
              }
            }
          }
        }

        if (loreContent != null && loreContent.isNotEmpty) {
          return {"role": "system", "content": loreContent};
        }

        return null;
      }
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }

  Future<void> _regenerateMessage(int chatId, int messageId, SettingsBase settings) async {
    await _repository.updateMessageActivity(messageId, false);
    final chat = await _repository.getChatById(chatId);
    final message = chat.messages.firstWhere((e) => e.id == messageId);
    final String? latestSummaryContent =
        chat.summaries.isNotEmpty && chat.summaries.last.content.trim().isNotEmpty
        ? chat.summaries.last.content.trim()
        : null;
    final systemContent = PromptRenderer.getSystemContent(
      settings: settings,
      chat: chat,
      summary: latestSummaryContent,
    );

    final userMessageText = message.parentId != null
        ? chat.messages.firstWhere((e) => e.id == message.parentId!).content
        : '';
    final messages = await _getMessages(chat, systemContent, settings, userMessageText);
    return _generationService.requestAiResponse(
      chatId: chat.id,
      charId: chat.char.id,
      settings: settings,
      formattedMessages: messages,
      isNew: true,
      parentId: message.parentId,
      lastActiveMsgId: message.id,
    );
  }

  Future<List<Map<String, String>>> _getMessages(
    Chat chat,
    String systemContent,
    SettingsBase settings,
    String userText,
  ) async {
    var accumulatedTokens =
        (await _calculateTokens(systemContent, settings)) +
        TokenLimits.templateTokens * 2 +
        TokenLimits.summaryTokens;

    final loreMessage = await _getLoreMessage(chat, settings, userText);
    if (loreMessage != null) {
      accumulatedTokens +=
          await _calculateTokens(loreMessage['content'] ?? '', settings) +
          TokenLimits.templateTokens;
    }

    final messages = <Map<String, String>>[
      {'role': 'system', 'content': systemContent},
    ];
    if (accumulatedTokens < settings.maxContextTokens) {
      for (var i = chat.messages.length - 1; i >= 0; --i) {
        var msg = chat.messages[i];
        if (msg.isActive) {
          final content = PromptRenderer.removeComments(msg.content);
          accumulatedTokens +=
              (await _calculateTokens(content, settings)) + TokenLimits.templateTokens;
          if (accumulatedTokens < settings.maxContextTokens) {
            messages.insert(1, {'role': msg.role.name, 'content': content});
          } else {
            break;
          }
        }
      }
    }

    if (loreMessage != null) {
      final targetIndex = math.max(1, messages.length - 2);
      messages.insert(targetIndex, loreMessage);
    }

    return messages;
  }

  Future<int> _calculateTokens(String text, SettingsBase settings) async {
    final tokens = await _tokenCounterService.countTokens(
      text: text,
      tokenizerPath: settings.tokenizerPath,
    );
    return tokens;
  }

  List<MessageView> _getChatActiveMV(List<Message> messages) {
    final Map<int, List<Message>> byParent = {};
    for (final msg in messages) {
      var list = byParent[msg.parentId ?? -1];
      list ??= byParent[msg.parentId ?? -1] = <Message>[];
      list.add(msg);
    }

    final messageViews = <MessageView>[];
    for (final msg in messages) {
      if (msg.isActive) {
        messageViews.add(
          MessageView.fromMessage(
            msg,
            msg.parentId != null ? byParent[msg.parentId]?.length ?? 1 : 1,
            msg.parentId != null ? (byParent[msg.parentId]?.indexOf(msg) ?? 0) + 1 : 1,
          ),
        );
      }
    }

    return messageViews;
  }

  void _onReceivedAiToken(ReceivedAiTokenEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;
    final message = event.message;
    if (currentState.chatId != message.chatId) return;

    if (message.status == MessageStatus.completed) {
      final chat = await _repository.getChatById(currentState.chatId);
      emit(currentState.copyWith(messages: _getChatActiveMV(chat.messages), isAiTyping: false));
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
      emit(currentState.copyWith(messages: _getChatActiveMV(updatedMessages), isAiTyping: true));
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
        messages: _getChatActiveMV(chat.messages),
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
            MessageView.fromMessage(
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
              1,
              1,
            ),
        ],
      ),
    );
  }

  Future<void> _onUpdateCharacter(UpdateCharacterEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;

    final char = await _charactersRepository.getCharacterById(currentState.char.id);

    emit(currentState.copyWith(char: char));
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
      emit(currentState.copyWith(summary: updatedChat.summaries.lastOrNull?.content ?? ''));
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
    final res = PromptRenderer.renderNames(text, charName: charName, userName: userName);
    return PromptRenderer.removeComments(res);
  }
}
