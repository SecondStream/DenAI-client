import 'dart:io';
import 'package:den_ai/application/env.dart';
import 'package:den_ai/models/models.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Chars,
    Lorebooks,
    CharLorebooks,
    LoreEntries,
    UserCards,
    Messages,
    Chats,
    Summaries,
    SettingsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = File(p.join(AppEnv.supportDir, 'app_v1.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
