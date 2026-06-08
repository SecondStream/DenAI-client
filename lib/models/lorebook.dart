import 'package:den_ai/models/lore_entry.dart';
import 'package:den_ai/models/persona.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lorebook.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Lorebook extends Persona {
  @JsonKey(defaultValue: "")
  final String about;
  final String cover;
  final List<LoreEntry> entries;

  Lorebook({
    required super.id,
    required super.name,
    required super.avatar,
    super.crop,
    required this.about,
    required this.cover,
    required this.entries,
  });

  @override
  String get avatar => cover;

  @override
  String? getAvatar(String baseUrl) =>
      cover.isNotEmpty && !cover.contains('default') ? '$baseUrl/$cover' : null;

  factory Lorebook.fromJson(Map<String, dynamic> json) => _$LorebookFromJson(json);
  Map<String, dynamic> toJson() => _$LorebookToJson(this);
}
