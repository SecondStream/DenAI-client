// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'char.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Char _$CharFromJson(Map<String, dynamic> json) => Char(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  avatar: json['avatar'] as String,
  crop: json['crop'] as String?,
  background: json['background'] as String?,
  appearance: json['appearance'] as String? ?? '',
  personality: json['personality'] as String? ?? '',
  scenario: json['scenario'] as String? ?? '',
  greeting: json['greeting'] as String? ?? '',
  prompt: json['prompt'] as String? ?? '',
);

Map<String, dynamic> _$CharToJson(Char instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar': instance.avatar,
  'crop': instance.crop,
  'background': instance.background,
  'appearance': instance.appearance,
  'personality': instance.personality,
  'scenario': instance.scenario,
  'greeting': instance.greeting,
  'prompt': instance.prompt,
};
