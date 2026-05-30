import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:chat_bot_client/repositories/provider/remote_provider.dart';
import 'package:dio/dio.dart';

import '../models/models.dart';

class ChatsRepository {
  static const String _baseEndpoint = '/chats';
  final RemoteProvider _remote;

  ChatsRepository(this._remote);

  Future<List<Chat>> getChats() async {
    final list = await _remote.get<List<dynamic>>('$_baseEndpoint/');
    if (list == null) return [];
    return list.map((json) => Chat.fromJson(json)).toList();
  }

  Future<Chat> getChatById(int chatId) async {
    final res = await _remote.get("$_baseEndpoint/$chatId");
    return Chat.fromJson(res);
  }

  Future<Chat?> getActiveChatByCharId(int charId) async {
    final res = await _remote.get("$_baseEndpoint/active/$charId");
    if (res != null) return Chat.fromJson(res);
    return null;
  }

  Future<Chat> switchMessageBranch(int messageId, MessageDirection direction) async {
    final response = await _remote.patch(
      "$_baseEndpoint/switch/$messageId",
      data: {"direction": direction.name},
    );
    return Chat.fromJson(response);
  }

  Future<Chat> editMessage(int messageId, String newContent) async {
    final response = await _remote.patch(
      "$_baseEndpoint/messages/$messageId",
      data: {"content": newContent},
    );
    return Chat.fromJson(response);
  }

  Future<Chat> deleteMessage(int messageId) async {
    final response = await _remote.delete("$_baseEndpoint/messages/$messageId");
    return Chat.fromJson(response);
  }

  Future<Stream<String>?> regenerateMessage(int chatId) async {
    final ResponseBody? r = await _remote.post<ResponseBody, Map<String, dynamic>>(
      '$_baseEndpoint/$chatId/regenerate',
      options: Options(responseType: ResponseType.stream),
    );

    if (r != null) {
      final stream = r.stream.transform(unit8BufferToString).cast<String>();

      return stream;
    }
    return null;
  }

  Future<void> updateChatUserCard(int chatId, int userCardId) async {
    await _remote.patch("$_baseEndpoint/$chatId/change_card", data: {"user_card_id": userCardId});
  }

  Future<Chat> createNewChat(int charId, int? userCardId) async {
    final data = {"title": "", "char_id": charId};
    if (userCardId != null) data['user_card_id'] = userCardId;
    final res = await _remote.post("$_baseEndpoint/create", data: data);
    return Chat.fromJson(res);
  }

  Future<String?> uploadImage(File file) async {
    final formData = FormData.fromMap({
      'image_file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    });

    final response = await _remote.post("$_baseEndpoint/upload-image", data: formData);
    return response['image_path'];
  }

  Future<Stream<String>?> sendMessage(int chatId, String text, String? imagePath) async {
    final ResponseBody? r = await _remote.post<ResponseBody, dynamic>(
      '$_baseEndpoint/$chatId/send',
      data: {"content": text, "image_path": imagePath},
      options: Options(responseType: ResponseType.stream),
    );

    if (r != null) {
      return r.stream.transform(unit8BufferToString).cast<String>();
    }
    return null;
  }

  Future<void> deleteChat(int chatId) async {
    await _remote.delete("$_baseEndpoint/del/$chatId");
  }

  Future<Chat> updateChatSummary(int chatId, String newSummary) async {
    final response = await _remote.patch(
      "$_baseEndpoint/$chatId/summary",
      data: {"content": newSummary},
    );
    return Chat.fromJson(response);
  }

  StreamTransformer<Uint8List, String> get unit8BufferToString =>
      StreamTransformer<Uint8List, String>.fromHandlers(
        handleData: (data, sink) {
          sink.add(utf8.decode(data, allowMalformed: true));
        },
      );
}
