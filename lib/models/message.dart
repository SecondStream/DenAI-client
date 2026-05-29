import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Message {
  final int id;
  final String role;
  final String content;
  final DateTime createdAt;
  @JsonKey(defaultValue: 1)
  final int currentIndex;
  @JsonKey(defaultValue: 1)
  final int totalVariants;

  Message({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.currentIndex = 1,
    this.totalVariants = 1,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  Message copyWith({String? content}) {
    return Message(id: id, role: role, content: content ?? this.content, createdAt: createdAt);
  }
}
