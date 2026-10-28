import 'dart:async';
import 'dart:io';
import 'package:den_ai/clients/openai_client.dart';
import 'package:den_ai/consts/consts.dart';
import 'package:den_ai/models/message.dart';
import 'package:den_ai/models/settings_base.dart';
import 'package:den_ai/models/stream_message.dart';
import 'package:den_ai/repositories/chats_repository.dart';
import 'package:den_ai/services/token_counter_service.dart';
import 'package:den_ai/tools/prompt_renderer.dart';

class ChatGenerationService {
  final OpenAIClient _client;
  final ChatsRepository _repository;
  final TokenCounterService _tokenCounterService;

  final StreamController<StreamMessage> _messageController =
      StreamController<StreamMessage>.broadcast();
  Stream<StreamMessage> get allMessagesStream => _messageController.stream;

  final Map<int, StreamSubscription<String>> _activeGenerations = {};
  final Map<int, Timer> _timers = {};

  ChatGenerationService(this._client, this._repository, this._tokenCounterService);

  Future<void> _rollbackAiAnswer({
    required int? parentId,
    required int? lastActiveMsgId,
    required bool isNew,
  }) async {
    if (isNew && parentId != null) {
      await _repository.deleteMessageRaw(parentId);
    } else if (!isNew && lastActiveMsgId != null) {
      await _repository.updateMessageActivity(lastActiveMsgId, true);
    }
  }

  Future<void> requestAiResponse({
    required int chatId,
    required int charId,
    required SettingsBase settings,
    required List<Map<String, String>> formattedMessages,
    required bool isNew,
    required int? parentId,
    required int? lastActiveMsgId,
    String? lastUserTextForError,
    File? lastUserImageForError,
  }) async {
    if (_activeGenerations.containsKey(chatId)) return;

    _messageController.add(
      StreamMessage(
        chatId: chatId,
        charId: charId,
        token: "",
        model: settings.modelName,
        status: MessageStatus.thinking,
      ),
    );

    bool isSuccess = true;
    String accumulatedText = "";

    int lastTokenTimestamp = DateTime.now().millisecondsSinceEpoch;
    _timers[chatId] = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - lastTokenTimestamp >= 500) {
        _messageController.add(
          StreamMessage(
            chatId: chatId,
            charId: charId,
            token: accumulatedText,
            model: settings.modelName,
            status: MessageStatus.typing,
          ),
        );
      }
    });

    final Stream<String> tokenStream = _client.sendMessage(
      settings: settings,
      messages: formattedMessages,
    );

    final subscription = tokenStream.listen(
      (String token) {
        lastTokenTimestamp = DateTime.now().millisecondsSinceEpoch;

        accumulatedText += token;

        _messageController.add(
          StreamMessage(
            chatId: chatId,
            charId: charId,
            token: accumulatedText,
            model: settings.modelName,
            status: MessageStatus.typing,
          ),
        );
      },
      onError: (Object error) async {
        isSuccess = false;
        await _rollbackAiAnswer(parentId: parentId, lastActiveMsgId: lastActiveMsgId, isNew: isNew);

        _messageController.addError(
          StreamMessageError(
            chatId: chatId,
            lastUserMessage: lastUserTextForError,
            imageFile: lastUserImageForError,
          ),
        );

        _cleanup(chatId);
      },
      onDone: () async {
        if (!isSuccess || accumulatedText.isEmpty) {
          _cleanup(chatId);
          return;
        }

        try {
          await _repository.insertMessage(
            chatId: chatId,
            role: MessageRole.assistant,
            content: accumulatedText,
            parentId: parentId,
            modelName: settings.modelName,
          );

          _messageController.add(
            StreamMessage(
              chatId: chatId,
              charId: charId,
              token: accumulatedText,
              model: settings.modelName,
              status: MessageStatus.completed,
            ),
          );
        } catch (e) {
          await _rollbackAiAnswer(
            parentId: parentId,
            lastActiveMsgId: lastActiveMsgId,
            isNew: isNew,
          );
          _messageController.addError(StreamMessageError(chatId: chatId));
        } finally {
          _cleanup(chatId);
        }
      },
      cancelOnError: false,
    );
    _activeGenerations[chatId] = subscription;
  }

  void stopGeneration(int chatId) {
    if (_activeGenerations.containsKey(chatId)) {
      _activeGenerations[chatId]?.cancel();
      _cleanup(chatId);
    }
  }

  void _cleanup(int chatId) {
    if (_timers.containsKey(chatId)) {
      _timers[chatId]?.cancel();
      _timers.remove(chatId);
    }
    _activeGenerations.remove(chatId);
  }

  Future<void> checkAndRunBackgroundSummarize({
    required int chatId,
    required SettingsBase settings,
  }) async {
    try {
      final chat = await _repository.getChatById(chatId);
      final lastSummary = chat.summaries.isNotEmpty ? chat.summaries.last : null;
      final systemContent = PromptRenderer.getSystemContent(
        settings: settings,
        chat: chat,
        summary: null,
      );

      final int maxTokens = (settings.maxContextTokens * 0.9).round();

      int accumulatedTokens =
          await _tokenCounterService.countTokens(
            text: systemContent,
            tokenizerPath: settings.tokenizerPath,
          ) +
          TokenLimits.summaryTokens +
          TokenLimits.templateTokens * 2;

      final List<Message> archiveMessages = <Message>[];
      final List<Message> liveMessages = <Message>[];

      bool allToArchive = accumulatedTokens >= maxTokens;
      bool firstPass = true;

      final List<Message> activeMessages = chat.messages.where((m) => m.isActive).toList();

      for (final msg in activeMessages.reversed) {
        if (firstPass) {
          firstPass = false;
          accumulatedTokens +=
              await _tokenCounterService.countTokens(
                text: msg.content,
                tokenizerPath: settings.tokenizerPath,
              ) +
              TokenLimits.templateTokens;
          continue;
        }

        if (lastSummary != null && msg.id <= lastSummary.lastSummarizedMessageId) {
          break;
        }

        if (allToArchive) {
          archiveMessages.insert(0, msg);
          continue;
        }

        accumulatedTokens +=
            await _tokenCounterService.countTokens(
              text: msg.content,
              tokenizerPath: settings.tokenizerPath,
            ) +
            TokenLimits.templateTokens;

        if (accumulatedTokens >= maxTokens) {
          allToArchive = true;
          archiveMessages.insert(0, msg);
        } else {
          liveMessages.insert(0, msg);
        }
      }

      if (archiveMessages.isNotEmpty) {
        final String historyForSummary = (archiveMessages + liveMessages)
            .map((m) => "${m.role == MessageRole.user ? 'User' : 'Assistant'}: ${m.content}")
            .join("\n");

        String summarizePrompt = DefaultSettings.summarizePrompt
            .replaceFirst(
              '{{previous_summary}}',
              lastSummary != null ? "Previous summary:\n${lastSummary.content}\n" : "",
            )
            .replaceFirst('{{new_messages}}', "New lines to summarize:\n$historyForSummary\n");

        final Stream<String> summaryStream = _client.sendMessage(
          settings: settings,
          messages: [
            {"role": "system", "content": summarizePrompt},
          ],
        );

        String newSummaryContent = "";
        await for (final token in summaryStream) {
          newSummaryContent += token;
        }

        if (newSummaryContent.trim().isNotEmpty) {
          final int anchorMessageId = liveMessages.isNotEmpty
              ? liveMessages.last.id
              : archiveMessages.last.id;
          await _repository.addSummary(chatId, anchorMessageId, newSummaryContent.trim());
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }
}
