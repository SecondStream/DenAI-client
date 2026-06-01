import 'package:den_ai/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Chat {
  final int id;
  final String title;
  final Char char;
  final List<Message> messages;
  final String? background;
  final UserCard? userCard;
  @JsonKey(defaultValue: "")
  final String summary;

  Chat({
    required this.id,
    required this.title,
    required this.char,
    required this.messages,
    required this.summary,
    this.background,
    this.userCard,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
