import 'package:json_annotation/json_annotation.dart';

part 'lore_entry.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoreEntry {
  final int id;
  final int lorebookId;
  final String title;
  @JsonKey(defaultValue: "")
  final String content;

  LoreEntry({
    required this.id,
    required this.lorebookId,
    required this.title,
    required this.content,
  });

  factory LoreEntry.fromJson(Map<String, dynamic> json) => _$LoreEntryFromJson(json);
  Map<String, dynamic> toJson() => _$LoreEntryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LoreEntryIn {
  final int? id;
  final int lorebookId;
  final String title;
  @JsonKey(defaultValue: "")
  final String content;

  LoreEntryIn({this.id, required this.lorebookId, required this.title, required this.content});

  factory LoreEntryIn.fromJson(Map<String, dynamic> json) => _$LoreEntryInFromJson(json);
  Map<String, dynamic> toJson() => _$LoreEntryInToJson(this);
}
