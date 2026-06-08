// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lorebook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lorebook _$LorebookFromJson(Map<String, dynamic> json) => Lorebook(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  avatar: json['avatar'] as String?,
  crop: json['crop'] as String?,
  about: json['about'] as String? ?? '',
  cover: json['cover'] as String,
  entries: (json['entries'] as List<dynamic>)
      .map((e) => LoreEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LorebookToJson(Lorebook instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'crop': instance.crop,
  'about': instance.about,
  'cover': instance.cover,
  'entries': instance.entries,
  'avatar': instance.avatar,
};
