import 'package:json_annotation/json_annotation.dart';

part 'model_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ModelInfo {
  final String name;
  final String sizeGb;

  ModelInfo({required this.name, required this.sizeGb});

  factory ModelInfo.fromJson(Map<String, dynamic> json) => _$ModelInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ModelInfoToJson(this);
}
