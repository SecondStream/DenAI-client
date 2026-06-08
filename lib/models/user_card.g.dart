// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCard _$UserCardFromJson(Map<String, dynamic> json) => UserCard(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  avatar: json['avatar'] as String?,
  crop: json['crop'] as String?,
  description: json['description'] as String? ?? '',
  isDefault: json['is_default'] as bool? ?? false,
);

Map<String, dynamic> _$UserCardToJson(UserCard instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar': instance.avatar,
  'crop': instance.crop,
  'description': instance.description,
  'is_default': instance.isDefault,
};
