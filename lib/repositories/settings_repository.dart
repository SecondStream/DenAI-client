import 'package:den_ai/consts/consts.dart';
import 'package:den_ai/models/provider.dart';
import 'package:den_ai/models/settings_base.dart';
import 'package:den_ai/repositories/base_repository.dart';
import 'package:drift/drift.dart';
import 'database.dart';

class SettingsRepository extends BaseRepository {
  SettingsRepository(super.db);

  Future<SettingsBase> getSettings() async {
    final query = db.select(db.settingsTable).join([
      innerJoin(db.providers, db.providers.id.equalsExp(db.settingsTable.providerId)),
    ])..where(db.settingsTable.id.equals(DefaultSettings.singleSettingsId));

    final List<TypedResult> rows = await query.get();

    if (rows.isNotEmpty) {
      final row = rows.first;
      final settingsData = row.readTable(db.settingsTable);
      final providerData = row.readTable(db.providers);

      return SettingsBase.fromDb(settingsData, provider: Provider.fromDb(providerData));
    }

    return await db.transaction(() async {
      final defaultProvider = ProvidersCompanion.insert(
        name: 'Ollama',
        url: 'http://localhost:11434/v1',
        key: 'OLLAMA_KEY',
      );
      final int newProviderId = await db.into(db.providers).insert(defaultProvider);
      final defaultSettings = SettingsTableCompanion.insert(
        id: const Value(DefaultSettings.singleSettingsId),
        modelName: 'google/gemma-4-31b-it',
        visionModelName: 'google/gemma-4-31b-it',
        embeddingModelName: 'baai/bge-m3',
        tokenizerPath: 'assets/tokenizers/gemma4.json',
        maxContextTokens: 4096,
        temperature: 0.7,
        minP: 0.05,
        topP: 0.9,
        repeatPenalty: 1.1,
        globalSystemPrompt: '',
        template: '',
        providerId: newProviderId,
      );
      await db.into(db.settingsTable).insert(defaultSettings);
      return await getSettings();
    });
  }

  Future<SettingsBase> saveSettings(SettingsBase settings) async {
    final settingsCompanion = SettingsTableCompanion(
      modelName: Value(settings.modelName),
      visionModelName: Value(settings.visionModelName),
      embeddingModelName: Value(settings.embeddingModelName),
      tokenizerPath: Value(settings.tokenizerPath),
      maxContextTokens: Value(settings.maxContextTokens),
      temperature: Value(settings.temperature),
      minP: Value(settings.minP),
      topP: Value(settings.topP),
      repeatPenalty: Value(settings.repeatPenalty),
      globalSystemPrompt: Value(settings.globalSystemPrompt),
      template: Value(settings.template),
      providerId: Value(settings.provider.id),
    );

    await (db.update(
      db.settingsTable,
    )..where((tbl) => tbl.id.equals(DefaultSettings.singleSettingsId))).write(settingsCompanion);

    return await getSettings();
  }

  Future<SettingsBase> updateActiveProviderId(int providerId) async {
    final settingsCompanion = SettingsTableCompanion(providerId: Value(providerId));

    // UPDATE settings_table SET provider_id = :providerId WHERE id = 1
    await (db.update(
      db.settingsTable,
    )..where((tbl) => tbl.id.equals(DefaultSettings.singleSettingsId))).write(settingsCompanion);

    return await getSettings();
  }

  Future<List<Provider>> getAllProviders() async {
    final List<ProviderData> rows = await (db.select(
      db.providers,
    )..orderBy([(tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc)])).get();

    return rows.map((row) => Provider.fromDb(row)).toList();
  }

  Future<Provider> saveProvider({
    int? id,
    required String name,
    required String url,
    required String key,
  }) async {
    final int finalId;

    if (id != null && id > 0) {
      finalId = id;
      final companion = ProvidersCompanion(name: Value(name), url: Value(url), key: Value(key));
      await (db.update(db.providers)..where((tbl) => tbl.id.equals(id))).write(companion);
    } else {
      final companion = ProvidersCompanion.insert(name: name, url: url, key: key);
      finalId = await db.into(db.providers).insert(companion);
    }

    final ProviderData freshRow = await (db.select(
      db.providers,
    )..where((tbl) => tbl.id.equals(finalId))).getSingle();
    return Provider.fromDb(freshRow);
  }

  Future<void> deleteProvider(int providerId) async {
    if (providerId == DefaultSettings.singleSettingsId) {
      throw ArgumentError('The base provider cannot be deleted.');
    }

    await db.transaction(() async {
      final currentSettings = await (db.select(
        db.settingsTable,
      )..where((tbl) => tbl.id.equals(DefaultSettings.singleSettingsId))).getSingle();

      if (currentSettings.providerId == providerId) {
        final fallbackCompanion = SettingsTableCompanion(
          providerId: Value(DefaultSettings.singleSettingsId),
        );
        await (db.update(db.settingsTable)
              ..where((tbl) => tbl.id.equals(DefaultSettings.singleSettingsId)))
            .write(fallbackCompanion);
      }

      await (db.delete(db.providers)..where((tbl) => tbl.id.equals(providerId))).go();
    });
  }
}
