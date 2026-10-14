import 'dart:async';
import 'dart:io';
import 'package:den_ai/clients/openai_client.dart';
import 'package:den_ai/models/message.dart';
import 'package:den_ai/models/settings_base.dart';
import 'package:den_ai/models/stream_message.dart';
import 'package:den_ai/repositories/chats_repository.dart';

class ChatGenerationService {
  final OpenAIClient _client;
  final ChatsRepository _repository;

  final StreamController<StreamMessage> _messageController =
      StreamController<StreamMessage>.broadcast();
  Stream<StreamMessage> get allMessagesStream => _messageController.stream;

  final Map<int, StreamSubscription<String>> _activeGenerations = {};

  ChatGenerationService({required OpenAIClient client, required ChatsRepository repository})
    : _client = client,
      _repository = repository;

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
        token: "",
        model: settings.modelName,
        status: MessageStatus.thinking,
      ),
    );

    String accumulatedText = "";

    final Stream<String> tokenStream = _client.sendMessage(
      settings: settings,
      messages: formattedMessages,
    );

    final subscription = tokenStream.listen(
      (String token) {
        accumulatedText += token;

        _messageController.add(
          StreamMessage(
            chatId: chatId,
            token: accumulatedText,
            model: settings.modelName,
            status: MessageStatus.typing,
          ),
        );
      },
      onError: (Object error) async {
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
    _activeGenerations.remove(chatId);
  }
}
