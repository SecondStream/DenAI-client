import 'package:den_ai/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'all_settings.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AllSettings {
  final List<ModelInfo> models;
  final List<String> tokenizers;
  final SettingsBase settings;

  AllSettings({required this.models, required this.tokenizers, required this.settings});

  factory AllSettings.fromJson(Map<String, dynamic> json) => _$AllSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AllSettingsToJson(this);
}
