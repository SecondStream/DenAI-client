import 'package:den_ai/models/lorebook.dart';
import 'package:den_ai/repositories/database.dart' show LoreEntryData;
import 'package:drift/drift.dart';

class LoreEntry {
  final int id;
  final int lorebookId;
  final String title;
  final String content;

  LoreEntry({required this.id, required this.lorebookId, required this.title, this.content = ""});

  factory LoreEntry.fromDb(LoreEntryData data) {
    return LoreEntry(
      id: data.id,
      lorebookId: data.lorebookId,
      title: data.title,
      content: data.content,
    );
  }
}

@DataClassName('LoreEntryData')
class LoreEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lorebookId => integer().references(Lorebooks, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get content => text().withDefault(const Constant(''))();
}
