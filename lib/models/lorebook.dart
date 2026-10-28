import 'dart:convert';
import 'package:den_ai/models/crop_data.dart';
import 'package:den_ai/models/persona.dart';
import 'package:den_ai/repositories/database.dart' show LorebookData;
import 'package:drift/drift.dart';
import 'char.dart';
import 'lore_entry.dart';
import 'package:path/path.dart' as p;

class Lorebook extends Persona {
  final int id;
  final String name;
  final String about;
  final String cover;
  final String? crop;
  final List<LoreEntry> entries;

  Lorebook({
    required this.id,
    required this.name,
    this.about = "",
    required this.cover,
    this.crop,
    required this.entries,
  });

  factory Lorebook.fromDb(LorebookData data, {required List<LoreEntry> entries}) {
    return Lorebook(
      id: data.id,
      name: data.name,
      about: data.about,
      cover: data.cover,
      crop: data.crop,
      entries: entries,
    );
  }

  Lorebook copyWith({
    int? id,
    String? name,
    String? about,
    String? cover,
    String? crop,
    List<LoreEntry>? entries,
  }) {
    return Lorebook(
      id: id ?? this.id,
      name: name ?? this.name,
      cover: cover ?? this.cover,
      entries: entries ?? this.entries.toList(),
    );
  }

  @override
  String? getAvatar(String baseUrl) =>
      cover.isNotEmpty && !cover.contains('default') ? p.join(baseUrl, cover) : null;

  @override
  CropData? getCropData() {
    if (crop == null || crop!.isEmpty) return null;
    final validJson = crop!.replaceAll("'", '"');
    final Map<String, dynamic> map = jsonDecode(validJson);
    return CropData.fromJson(map);
  }

  List<String> getEntriesTexts() {
    final texts = <String>[];
    for (final entry in entries) {
      texts.add('${entry.title}\n${entry.content}');
    }
    return texts;
  }
}

@DataClassName('LorebookData')
class Lorebooks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get about => text().withDefault(const Constant(''))();
  TextColumn get cover => text()();
  TextColumn get crop => text().nullable()();
}

class CharLorebooks extends Table {
  IntColumn get charId => integer().references(Chars, #id, onDelete: KeyAction.cascade)();
  IntColumn get lorebookId => integer().references(Lorebooks, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {charId, lorebookId};
}
