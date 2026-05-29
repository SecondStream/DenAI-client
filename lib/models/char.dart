import 'package:json_annotation/json_annotation.dart';

part 'char.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Char {
  final int id;
  final String name;
  final String avatar;
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

  Char(
    this.id,
    this.name,
    this.avatar,
    this.background,
    this.appearance,
    this.personality,
    this.scenario,
    this.greeting,
    this.prompt,
  );

  factory Char.fromJson(Map<String, dynamic> json) => _$CharFromJson(json);
  Map<String, dynamic> toJson() => _$CharToJson(this);

  String? getAvatar(String baseUrl) =>
      avatar.isNotEmpty && !avatar.contains('default_user.png') ? '$baseUrl/$avatar' : null;
  String? getBackground(String baseUrl) =>
      background != null && background!.isNotEmpty ? '$baseUrl/$background' : null;
}
