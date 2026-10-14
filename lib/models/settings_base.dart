import 'package:drift/drift.dart';

class SettingsBase {
  final String modelName;
  final String visionModelName;
  final String tokenizerPath;
  final int maxContextTokens;
  final double temperature;
  final double minP;
  final double topP;
  final double repeatPenalty;
  final String globalSystemPrompt;
  final String template;
  final String provider;

  SettingsBase({
    required this.modelName,
    required this.visionModelName,
    required this.tokenizerPath,
    required this.maxContextTokens,
    required this.temperature,
    required this.minP,
    required this.topP,
    required this.repeatPenalty,
    required this.globalSystemPrompt,
    required this.template,
    required this.provider,
  });
}

@DataClassName('SettingsData')
class SettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get modelName => text()();
  TextColumn get visionModelName => text()();
  TextColumn get tokenizerPath => text()();
  IntColumn get maxContextTokens => integer()();

  RealColumn get temperature => real()();
  RealColumn get minP => real()();
  RealColumn get topP => real()();
  RealColumn get repeatPenalty => real()();

  TextColumn get globalSystemPrompt => text()();
  TextColumn get template => text()();
  TextColumn get provider => text()();

  @override
  Set<Column> get primaryKey => {id};
}
