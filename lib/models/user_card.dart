import 'package:den_ai/models/persona.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_card.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserCard extends Persona {
  @JsonKey(defaultValue: "")
  final String description;
  @JsonKey(defaultValue: false)
  final bool isDefault;

  factory UserCard.fromJson(Map<String, dynamic> json) => _$UserCardFromJson(json);

  UserCard({
    required super.id,
    required super.name,
    required super.avatar,
    super.crop,
    required this.description,
    required this.isDefault,
  });

  Map<String, dynamic> toJson() => _$UserCardToJson(this);
}
