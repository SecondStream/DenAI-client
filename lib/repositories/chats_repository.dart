import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:den_ai/repositories/base_repository.dart';
import 'package:den_ai/repositories/provider/remote_provider.dart';
import 'package:dio/dio.dart';

import '../models/models.dart';

class ChatsRepository extends BaseRepository {
  final _messageController = StreamController<StreamMessage>.broadcast();
  Stream<StreamMessage> get allMessagesStream => _messageController.stream;

  ChatsRepository(RemoteProvider remote) : super(remote, '/chats');

  Future<List<Chat>> getChats() async {
    final list = await remote.get<List<dynamic>>('$endpoint/');
    if (list == null) return [];
    return list.map((json) => Chat.fromJson(json)).toList();
  }

  Future<Chat> getChatById(int chatId) async {
    final res = await remote.get("$endpoint/$chatId");
    return Chat.fromJson(res);
  }

  Future<Chat?> getActiveChatByCharId(int charId) async {
    final res = await remote.get("$endpoint/active/$charId");
    if (res != null) return Chat.fromJson(res);
    return null;
  }

  Future<Chat> switchMessageBranch(int messageId, MessageDirection direction) async {
    final response = await remote.patch(
      "$endpoint/switch/$messageId",
      data: {"direction": direction.name},
    );
    return Chat.fromJson(response);
  }

  Future<Chat> editMessage(int messageId, String newContent) async {
    final response = await remote.patch(
      "$endpoint/messages/$messageId",
      data: {"content": newContent},
    );
    return Chat.fromJson(response);
  }

  Future<Chat> deleteMessage(int messageId) async {
    final response = await remote.delete("$endpoint/messages/$messageId");
    return Chat.fromJson(response);
  }

  Future<void> regenerateMessage(int chatId) async {
    try {
      final ResponseBody? r = await remote.post<ResponseBody, Map<String, dynamic>>(
        '$endpoint/$chatId/regenerate',
        options: Options(responseType: ResponseType.stream),
      );

      if (r != null) {
        final stream = r.stream
            .transform(unit8BufferToString)
            .transform(const LineSplitter())
            .where((line) => line.trim().isNotEmpty) // maybe ping
            .map((jsonStr) => StreamMessage.fromJson(jsonDecode(jsonStr)));

        await for (final message in stream) {
          _messageController.add(message);
        }
      }
    } catch (e) {
      _messageController.addError(StreamMessageError(chatId: chatId));
    }
  }

  Future<void> updateChatUserCard(int chatId, int userCardId) async {
    await remote.patch("$endpoint/$chatId/change_card", data: {"user_card_id": userCardId});
  }

  Future<Chat> createNewChat(int charId, int? userCardId) async {
    final data = {"title": "", "char_id": charId};
    if (userCardId != null) data['user_card_id'] = userCardId;
    final res = await remote.post("$endpoint/create", data: data);
    return Chat.fromJson(res);
  }

  Future<String?> uploadImage(File file) async {
    final formData = FormData.fromMap({
      'image_file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    });

    final response = await remote.post("$endpoint/upload-image", data: formData);
    return response['image_path'];
  }

  Future<void> sendMessage(int chatId, String text, String? imagePath, File? imageFile) async {
    try {
      final ResponseBody? r = await remote.post<ResponseBody, dynamic>(
        '$endpoint/$chatId/send',
        data: {"content": text, "image_path": imagePath},
        options: Options(responseType: ResponseType.stream),
      );

      if (r != null) {
        final stream = r.stream
            .transform(unit8BufferToString)
            .transform(const LineSplitter())
            .where((line) => line.trim().isNotEmpty) // maybe ping
            .map((jsonStr) => StreamMessage.fromJson(jsonDecode(jsonStr)));

        await for (final message in stream) {
          _messageController.add(message);
        }
      }
    } catch (e) {
      _messageController.addError(
        StreamMessageError(chatId: chatId, lastUserMessage: text, imageFile: imageFile),
      );
    }
  }

  Future<void> deleteChat(int chatId) async {
    await remote.delete("$endpoint/del/$chatId");
  }

  Future<Chat> updateChatSummary(int chatId, String newSummary) async {
    final response = await remote.patch("$endpoint/$chatId/summary", data: {"content": newSummary});
    return Chat.fromJson(response);
  }

  StreamTransformer<Uint8List, String> get unit8BufferToString =>
      StreamTransformer<Uint8List, String>.fromHandlers(
        handleData: (data, sink) {
          sink.add(utf8.decode(data, allowMalformed: true));
        },
      );

  void dispose() {
    _messageController.close();
  }
}
