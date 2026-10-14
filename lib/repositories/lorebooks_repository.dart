import 'dart:convert';
import 'package:den_ai/repositories/base_repository.dart';
import 'package:den_ai/repositories/database.dart';
import 'package:den_ai/models/models.dart';
import 'package:drift/drift.dart';

class LorebooksRepository extends BaseRepository {
  LorebooksRepository(super.db);

  Future<List<Lorebook>> getAllLorebooks() async {
    final rows = await db.select(db.lorebooks).get();
    return rows.map((row) => Lorebook.fromDb(row, entries: [])).toList();
  }

  Future<Lorebook> getLorebook(int id) async {
    final query = db.select(db.lorebooks).join([
      leftOuterJoin(db.loreEntries, db.loreEntries.lorebookId.equalsExp(db.lorebooks.id)),
    ])..where(db.lorebooks.id.equals(id));

    final List<TypedResult> rows = await query.get();

    if (rows.isEmpty) {
      throw StateError('Lorebook not found');
    }

    final lorebookData = rows.first.readTable(db.lorebooks);

    final List<LoreEntry> finalEntries = <LoreEntry>[];
    for (final row in rows) {
      final entryData = row.readTableOrNull(db.loreEntries);

      if (entryData != null) {
        finalEntries.add(LoreEntry.fromDb(entryData));
      }
    }

    return Lorebook.fromDb(lorebookData, entries: finalEntries);
  }

  Future<void> deleteLorebook(int id) async {
    await (db.delete(db.lorebooks)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<Lorebook> saveLorebook({
    int? id,
    required String name,
    required String about,
    CropData? cropData,
    String? coverPath,
  }) async {
    int finalId;
    final String? cropString = cropData != null ? jsonEncode(cropData.toJson()) : null;

    if (id != null && id > 0) {
      finalId = id;
      final companion = LorebooksCompanion(
        name: Value(name),
        about: Value(about),
        crop: cropString != null ? Value(cropString) : const Value.absent(),
        cover: coverPath != null ? Value(coverPath) : const Value.absent(),
      );
      await (db.update(db.lorebooks)..where((tbl) => tbl.id.equals(id))).write(companion);
    } else {
      final finalCover = coverPath ?? "assets/covers/default_lorebook.png";
      final companion = LorebooksCompanion.insert(
        name: name,
        about: Value(about),
        cover: finalCover,
        crop: Value(cropString),
      );
      finalId = await db.into(db.lorebooks).insert(companion);
    }

    return await getLorebook(finalId);
  }

  Future<Lorebook> saveLoreEntry(int? id, int lorebookId, String title, String content) async {
    return await db.transaction(() async {
      if (id != null && id > 0) {
        final companion = LoreEntriesCompanion(
          lorebookId: Value(lorebookId),
          title: Value(title),
          content: Value(content),
        );

        await (db.update(db.loreEntries)..where((tbl) => tbl.id.equals(id))).write(companion);
      } else {
        final companion = LoreEntriesCompanion.insert(
          lorebookId: lorebookId,
          title: title,
          content: Value(content),
        );

        await db.into(db.loreEntries).insert(companion);
      }

      return await getLorebook(lorebookId);
    });
  }

  Future<void> deleteLoreEntry(int id) async {
    await (db.delete(db.loreEntries)..where((tbl) => tbl.id.equals(id))).go();
  }
}
