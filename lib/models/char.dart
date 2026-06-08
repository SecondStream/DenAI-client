import 'package:den_ai/models/lorebook.dart';
import 'package:den_ai/models/persona.dart';
import 'package:json_annotation/json_annotation.dart';

part 'char.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Char extends Persona {
  final String? background;
  @JsonKey(defaultValue: "")
  final String appearance;
  @JsonKey(defaultValue: "")
  final String personality;
  @JsonKey(defaultValue: "")
  final String scenario;
  @JsonKey(defaultValue: "")
  final String greeting;
  @JsonKey(defaultValue: "")
  final String prompt;
  @JsonKey(defaultValue: [])
  final List<Lorebook> lorebooks;

  factory Char.fromJson(Map<String, dynamic> json) => _$CharFromJson(json);

  Char({
    required super.id,
    required super.name,
    required super.avatar,
    super.crop,
    this.background,
    required this.appearance,
    required this.personality,
    required this.scenario,
    required this.greeting,
    required this.prompt,
    required this.lorebooks,
  });
  Map<String, dynamic> toJson() => _$CharToJson(this);

  String? getBackground(String baseUrl) =>
      background != null && background!.isNotEmpty ? '$baseUrl/$background' : null;
}
