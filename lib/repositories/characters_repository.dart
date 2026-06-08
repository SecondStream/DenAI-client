import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/base_repository.dart';
import 'package:den_ai/repositories/provider/remote_provider.dart';
import 'package:dio/dio.dart';

class CharactersRepository extends BaseRepository {
  List<Char>? _cache;
  CharactersRepository(RemoteProvider remote) : super(remote, '/chars');

  Future<List<Char>> getCharacters() {
    return _getCharacters();
  }

  Future<Char?> getCharacterById(int characterId) async {
    final characters = await _getCharacters();
    return characters.where((e) => e.id == characterId).firstOrNull;
  }

  Future<void> deleteCharacter(int charId) async {
    await remote.delete("$endpoint/$charId");
    _clearCache();
  }

  Future<Char> saveCharacter({
    int? id,
    required String name,
    required String appearance,
    required String personality,
    required String scenario,
    required String greeting,
    required String prompt,
    required List<int> lorebookIds,
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
      'lorebook_ids': jsonEncode(lorebookIds),
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
    _clearCache();
    return Char.fromJson(response);
  }

  Future<List<Char>> _getCharacters() async {
    var cache = _cache;
    if (cache == null) {
      final list = await remote.get<List<dynamic>>('$endpoint/');
      if (list == null) {
        cache = [];
      } else {
        cache = list.map((json) => Char.fromJson(json)).toList();
      }
    }

    return _cache = cache;
  }

  void _clearCache() {
    _cache = null;
  }
}
