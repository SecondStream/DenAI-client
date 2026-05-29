import 'dart:async';
import 'dart:io';

import 'package:chat_bot_client/models/models.dart';
import 'package:chat_bot_client/repositories/provider/remote_provider.dart';
import 'package:dio/dio.dart';

class CharactersRepository {
  static const String _baseEndpoint = '/chars';
  final RemoteProvider _remote;

  CharactersRepository(this._remote);

  Future<List<Char>> getCharacters() async {
    final list = await _remote.get<List<dynamic>>('$_baseEndpoint/');
    if (list == null) return [];
    return list.map((json) => Char.fromJson(json)).toList();
  }

  Future<Char> getCharacterById(int characterId) async {
    final res = await _remote.get("$_baseEndpoint/$characterId");
    return Char.fromJson(res);
  }

  Future<void> deleteCharacter(int charId) async {
    await _remote.delete("$_baseEndpoint/del/$charId");
  }

  Future<Char> saveCharacter({
    int? id,
    required String name,
    required String appearance,
    required String personality,
    required String scenario,
    required String greeting,
    required String prompt,
    File? avatarFile,
    File? backgroundFile,
  }) async {
    final Map<String, dynamic> formMap = {
      'name': name,
      'appearance': appearance,
      'personality': personality,
      'scenario': scenario,
      'greeting': greeting,
      'prompt': prompt,
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

    if (backgroundFile != null) {
      formMap['background_file'] = await MultipartFile.fromFile(
        backgroundFile.path,
        filename: backgroundFile.path.split(Platform.pathSeparator).last,
      );
    }

    final formData = FormData.fromMap(formMap);
    final response = await _remote.put('$_baseEndpoint/save', data: formData);
    return Char.fromJson(response);
  }
}
