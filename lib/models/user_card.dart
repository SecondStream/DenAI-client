import 'package:json_annotation/json_annotation.dart';

part 'user_card.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserCard {
  final int id;
  final String name;
  final String avatar;
  @JsonKey(defaultValue: "")
  final String description;
  @JsonKey(defaultValue: false)
  final bool isDefault;

  UserCard({
    required this.id,
    required this.name,
    required this.avatar,
    required this.description,
    required this.isDefault,
  });

  factory UserCard.fromJson(Map<String, dynamic> json) => _$UserCardFromJson(json);
  Map<String, dynamic> toJson() => _$UserCardToJson(this);

  String? getAvatar(String baseUrl) =>
      avatar.isNotEmpty && !avatar.contains('default_user.png') ? '$baseUrl/$avatar' : null;
}
