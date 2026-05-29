import 'dart:async';
import 'dart:io';

import 'package:chat_bot_client/models/models.dart';
import 'package:chat_bot_client/repositories/provider/remote_provider.dart';
import 'package:dio/dio.dart';

class UserCardsRepository {
  static const String _baseEndpoint = '/user_cards';
  final RemoteProvider _remote;

  List<UserCard>? _cache;
  UserCard? _defaultCard;

  UserCardsRepository(this._remote);

  Future<List<UserCard>> getUserCards() async {
    var cache = _cache;
    if (cache == null) {
      final list = await _remote.get<List<dynamic>>('$_baseEndpoint/');
      if (list == null) {
        cache = [];
      } else {
        cache = list.map((json) => UserCard.fromJson(json)).toList();
      }
    }

    return _cache = cache;
  }

  Future<UserCard> getDefaultUserCard() async {
    if (_defaultCard == null) {
      final res = await _remote.get("$_baseEndpoint/default");
      return _defaultCard = UserCard.fromJson(res);
    }
    return _defaultCard!;
  }

  Future<void> deleteUserCard(int id) async {
    await _remote.delete("$_baseEndpoint/del/$id");
    _clearCache();
  }

  Future<UserCard> saveUserCard({
    int? id,
    required String name,
    required String description,
    bool isDefault = false,
    File? avatarFile,
  }) async {
    final Map<String, dynamic> formMap = {
      'name': name,
      'description': description,
      'is_default': isDefault,
    };

    if (id != null && id > 0) {
      formMap['id'] = id.toString();
    }

    if (avatarFile != null) {
      formMap['avatar_file'] = await MultipartFile.fromFile(
        avatarFile.path,
        filename: avatarFile.path.split(Platform.pathSeparator).last,
      );
    }

    final formData = FormData.fromMap(formMap);
    final response = await _remote.put('$_baseEndpoint/save', data: formData);
    final saved = UserCard.fromJson(response);
    _clearCache();
    return saved;
  }

  void _clearCache() {
    _cache = null;
    _defaultCard = null;
  }
}
