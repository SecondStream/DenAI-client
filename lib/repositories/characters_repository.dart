import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/base_repository.dart';
import 'package:den_ai/repositories/provider/remote_provider.dart';
import 'package:dio/dio.dart';

class CharactersRepository extends BaseRepository {
  CharactersRepository(RemoteProvider remote) : super(remote, '/chars');

  Future<List<Char>> getCharacters() async {
    final list = await remote.get<List<dynamic>>(endpoint);
    if (list == null) return [];
    return list.map((json) => Char.fromJson(json)).toList();
  }

  Future<Char> getCharacterById(int characterId) async {
    final res = await remote.get("$endpoint/$characterId");
    return Char.fromJson(res);
  }

  Future<void> deleteCharacter(int charId) async {
    await remote.delete("$endpoint/$charId");
  }

  Future<Char> saveCharacter({
    int? id,
    required String name,
    required String appearance,
    required String personality,
    required String scenario,
    required String greeting,
    required String prompt,
    CropData? cropData,
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
      'crop': cropData != null ? jsonEncode(cropData.toJson()) : null,
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
    final response = await remote.put('$endpoint/', data: formData);
    return Char.fromJson(response);
  }
}
