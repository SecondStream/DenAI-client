import 'package:den_ai/models/provider.dart';
import 'package:den_ai/repositories/database.dart' show SettingsData;
import 'package:drift/drift.dart';

class SettingsBase {
  final String modelName;
  final String visionModelName;
  final String embeddingModelName;
  final bool embeddingEnabled;
  final String tokenizerPath;
  final int maxContextTokens;
  final double temperature;
  final double minP;
  final double topP;
  final double repeatPenalty;
  final String globalSystemPrompt;
  final String template;
  final Provider provider;

  SettingsBase({
    required this.modelName,
    required this.visionModelName,
    required this.embeddingModelName,
    required this.tokenizerPath,
    required this.maxContextTokens,
    required this.temperature,
    required this.minP,
    required this.topP,
    required this.repeatPenalty,
    required this.globalSystemPrompt,
    required this.template,
    required this.provider,
    this.embeddingEnabled = true,
  });

  factory SettingsBase.fromDb(SettingsData data, {required Provider provider}) {
    return SettingsBase(
      modelName: data.modelName,
      visionModelName: data.visionModelName,
      embeddingModelName: data.embeddingModelName,
      embeddingEnabled: data.embeddingEnabled,
      tokenizerPath: data.tokenizerPath,
      maxContextTokens: data.maxContextTokens,
      temperature: data.temperature,
      minP: data.minP,
      topP: data.topP,
      repeatPenalty: data.repeatPenalty,
      globalSystemPrompt: data.globalSystemPrompt,
      template: data.template,
      provider: provider,
    );
  }

  SettingsBase copy() {
    return SettingsBase(
      modelName: modelName,
      visionModelName: visionModelName,
      embeddingModelName: embeddingModelName,
      tokenizerPath: tokenizerPath,
      maxContextTokens: maxContextTokens,
      temperature: temperature,
      minP: minP,
      topP: topP,
      repeatPenalty: repeatPenalty,
      globalSystemPrompt: globalSystemPrompt,
      template: template,
      provider: provider.copy(),
    );
  }
}

@DataClassName('SettingsData')
class SettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get modelName => text()();
  TextColumn get visionModelName => text()();
  TextColumn get embeddingModelName => text()();
  BoolColumn get embeddingEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get tokenizerPath => text()();
  IntColumn get maxContextTokens => integer()();

  RealColumn get temperature => real()();
  RealColumn get minP => real()();
  RealColumn get topP => real()();
  RealColumn get repeatPenalty => real()();

  TextColumn get globalSystemPrompt => text()();
  TextColumn get template => text()();

  IntColumn get providerId => integer().references(Providers, #id)();
}
