import 'dart:convert';
import 'dart:io';
import 'package:den_ai/repositories/base_repository.dart';
import 'package:den_ai/repositories/provider/remote_provider.dart';
import 'package:den_ai/models/models.dart';
import 'package:dio/dio.dart';

class LorebooksRepository extends BaseRepository {
  LorebooksRepository(RemoteProvider remote) : super(remote, '/lorebooks');

  Future<List<Lorebook>> getAllLorebooks() async {
    final list = await remote.get<List<dynamic>>("$endpoint/");
    if (list != null) return list.map((json) => Lorebook.fromJson(json)).toList();
    return [];
  }

  Future<Lorebook> getLorebook(int id) async {
    final response = await remote.get("$endpoint/$id");
    return Lorebook.fromJson(response);
  }

  Future<void> deleteLorebook(int id) async {
    await remote.delete("$endpoint/$id");
  }

  Future<Lorebook> saveLorebook({
    int? id,
    required String name,
    required String about,
    CropData? cropData,
    File? coverFile,
  }) async {
    final Map<String, dynamic> formMap = {
      'name': name,
      'about': about,
      'crop': cropData != null ? jsonEncode(cropData.toJson()) : null,
    };

    if (id != null && id > 0) {
      formMap['id'] = id.toString();
    }

    if (coverFile != null) {
      formMap['cover_file'] = await MultipartFile.fromFile(
        coverFile.path,
        filename: coverFile.path.split(Platform.pathSeparator).last,
      );
    }

    final response = await remote.put("$endpoint/", data: FormData.fromMap(formMap));
    return Lorebook.fromJson(response);
  }

  Future<Lorebook> saveLoreEntry(LoreEntryIn entryIn) async {
    final response = await remote.put("$endpoint/entry", data: entryIn.toJson());
    return Lorebook.fromJson(response);
  }

  Future<void> deleteLoreEntry(int id) async {
    await remote.delete("$endpoint/entry/$id");
  }
}
