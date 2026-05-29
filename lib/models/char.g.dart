// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'char.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Char _$CharFromJson(Map<String, dynamic> json) => Char(
  (json['id'] as num).toInt(),
  json['name'] as String,
  json['avatar'] as String,
  json['background'] as String?,
  json['appearance'] as String? ?? '',
  json['personality'] as String? ?? '',
  json['scenario'] as String? ?? '',
  json['greeting'] as String? ?? '',
  json['prompt'] as String? ?? '',
);

Map<String, dynamic> _$CharToJson(Char instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar': instance.avatar,
  'background': instance.background,
  'appearance': instance.appearance,
  'personality': instance.personality,
  'scenario': instance.scenario,
  'greeting': instance.greeting,
  'prompt': instance.prompt,
};
