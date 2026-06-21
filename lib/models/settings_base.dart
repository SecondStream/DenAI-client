import 'package:json_annotation/json_annotation.dart';

part 'settings_base.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
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
    required this.provider,
  });

  factory SettingsBase.fromJson(Map<String, dynamic> json) => _$SettingsBaseFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsBaseToJson(this);
}
