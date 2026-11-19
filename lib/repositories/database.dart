import 'dart:io';
import 'package:den_ai/application/env.dart';
import 'package:den_ai/models/models.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:den_ai/repositories/migrations/schema_versions.dart';

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
    Providers,
    Models,
    Statistics,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        await transaction(() async {
          await m.runMigrationSteps(
            from: from,
            to: to,
            steps: migrationSteps(
              from1To2: (m, schema) async {
                await m.addColumn(schema.chars, schema.chars.notes);
              },
              from2To3: (m, schema) async {
                await m.addColumn(schema.chats, schema.chats.voice);
              },
              from3To4: (m, schema) async {
                await m.createTable(schema.models);
                await m.addColumn(schema.settingsTable, schema.settingsTable.embeddingEnabled);
              },
              from4To5: (m, schema) async {
                await m.createTable(schema.statistics);
                await into(schema.statistics).insert(
                  RawValuesInsertable({
                    'event_type': Variable.withString(StatEventType.appLaunchCount.name),
                    'payload': Variable.withString('1'),
                    'updated_at': Variable.withDateTime(DateTime.now()),
                  }),
                );
              },
              from5To6: (m, schema) async {
                await m.alterTable(
                  TableMigration(
                    schema.chars,
                    newColumns: [schema.chars.type],
                    columnTransformer: {
                      schema.chars.type: Constant(CharType.user.name),
                    },
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = File(p.join(AppEnv.supportDir, 'app_v1.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
