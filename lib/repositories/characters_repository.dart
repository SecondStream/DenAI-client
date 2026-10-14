import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:den_ai/repositories/database.dart'
    show LorebookData, CharsCompanion, CharLorebooksCompanion;
import 'package:drift/drift.dart';

import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/base_repository.dart';

class CharactersRepository extends BaseRepository {
  CharactersRepository(super.db);

  Future<List<Char>> getCharacters() async {
    final rows = await db.select(db.chars).get();
    return rows.map((row) => Char.fromDb(row, lorebooks: [])).toList();
  }

  Future<Char?> getCharacterById(int characterId) async {
    final query = db.select(db.chars).join([
      leftOuterJoin(db.charLorebooks, db.charLorebooks.charId.equalsExp(db.chars.id)),
      leftOuterJoin(db.lorebooks, db.lorebooks.id.equalsExp(db.charLorebooks.lorebookId)),
      leftOuterJoin(db.loreEntries, db.loreEntries.lorebookId.equalsExp(db.lorebooks.id)),
    ])..where(db.chars.id.equals(characterId));
    final List<TypedResult> rows = await query.get();
    if (rows.isEmpty) return null;
    final charData = rows.first.readTable(db.chars);
    final Map<int, LorebookData> uniqueBooks = {};
    final Map<int, List<LoreEntry>> bookEntries = {};
    for (final row in rows) {
      final bookData = row.readTableOrNull(db.lorebooks);
      final entryData = row.readTableOrNull(db.loreEntries);

      if (bookData != null) {
        uniqueBooks[bookData.id] = bookData;

        if (entryData != null) {
          final entriesList = bookEntries.putIfAbsent(bookData.id, () => <LoreEntry>[]);
          if (!entriesList.any((e) => e.id == entryData.id)) {
            entriesList.add(
              LoreEntry(
                id: entryData.id,
                lorebookId: entryData.lorebookId,
                title: entryData.title,
                content: entryData.content,
              ),
            );
          }
        }
      }
    }

    final List<Lorebook> finalLorebooks = uniqueBooks.values.map((bData) {
      return Lorebook(
        id: bData.id,
        name: bData.name,
        about: bData.about,
        cover: bData.cover,
        crop: bData.crop,
        entries: bookEntries[bData.id] ?? <LoreEntry>[],
      );
    }).toList();

    return Char.fromDb(charData, lorebooks: finalLorebooks);
  }

  Future<Char?> loadByCard(File card) async {
    return null; // TODO
    // final formMap = {
    //   'card': await MultipartFile.fromFile(
    //     card.path,
    //     filename: card.path.split(Platform.pathSeparator).last,
    //   ),
    // };
    // final formData = FormData.fromMap(formMap);
    // final response = await remote.post('$endpoint/card', data: formData);
    // _clearCache();
    // return Char.fromJson(response);
  }

  Future<File?> loadAvatar(String url) async {
    return null; // TODO
    // return remote.download(url);
  }

  Future<int> deleteCharacter(int id) async {
    return await (db.delete(db.chars)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<String?> exportCard({
    int? id,
    required String name,
    required String appearance,
    required String personality,
    required String scenario,
    required String greeting,
    required String prompt,
    required List<int> lorebookIds,
    File? avatarFile,
  }) async {
    return null; // TODO
    // final Map<String, dynamic> formMap = {
    //   'name': name,
    //   'appearance': appearance,
    //   'personality': personality,
    //   'scenario': scenario,
    //   'greeting': greeting,
    //   'prompt': prompt,
    //   'lorebook_ids': jsonEncode(lorebookIds),
    // };

    // if (id != null && id > 0) {
    //   formMap['id'] = id.toString();
    // }

    // if (avatarFile != null) {
    //   formMap['avatar_file'] = await MultipartFile.fromFile(
    //     avatarFile.path,
    //     filename: avatarFile.path.split(Platform.pathSeparator).last,
    //   );
    // }

    // final formData = FormData.fromMap(formMap);
    // return await remote.post('$endpoint/card-export', data: formData);
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
    String? avatarPath,
    String? backgroundPath,
  }) async {
    return await db.transaction(() async {
      int finalId;
      final String? crop = cropData != null ? jsonEncode(cropData.toJson()) : null;

      if (id != null && id > 0) {
        finalId = id;
        final companion = CharsCompanion(
          name: Value(name),
          appearance: Value(appearance),
          personality: Value(personality),
          scenario: Value(scenario),
          greeting: Value(greeting),
          prompt: Value(prompt),
          crop: crop != null ? Value(crop) : const Value.absent(),
          avatar: avatarPath != null ? Value(avatarPath) : const Value.absent(),
          background: backgroundPath != null ? Value(backgroundPath) : const Value.absent(),
        );

        await (db.update(db.chars)..where((tbl) => tbl.id.equals(id))).write(companion);
        await (db.delete(db.charLorebooks)..where((tbl) => tbl.charId.equals(id))).go();
      } else {
        final finalAvatar = avatarPath ?? "assets/avatars/default.png";
        final companion = CharsCompanion.insert(
          name: name,
          appearance: Value(appearance),
          personality: Value(personality),
          scenario: Value(scenario),
          greeting: Value(greeting),
          prompt: Value(prompt),
          crop: Value(crop),
          avatar: Value(finalAvatar),
          background: Value(backgroundPath),
        );

        finalId = await db.into(db.chars).insert(companion);
      }

      for (final bookId in lorebookIds) {
        await db
            .into(db.charLorebooks)
            .insert(CharLorebooksCompanion.insert(charId: finalId, lorebookId: bookId));
      }

      final charRow = await (db.select(
        db.chars,
      )..where((tbl) => tbl.id.equals(finalId))).getSingle();

      return Char.fromDb(charRow, lorebooks: const <Lorebook>[]);
    });
  }
}
