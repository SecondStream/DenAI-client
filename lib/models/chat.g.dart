// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  char: Char.fromJson(json['char'] as Map<String, dynamic>),
  messages: (json['messages'] as List<dynamic>)
      .map((e) => Message.fromJson(e as Map<String, dynamic>))
      .toList(),
  summary: json['summary'] as String? ?? '',
  background: json['background'] as String?,
  userCard: json['user_card'] == null
      ? null
      : UserCard.fromJson(json['user_card'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'char': instance.char,
  'messages': instance.messages,
  'background': instance.background,
  'user_card': instance.userCard,
  'summary': instance.summary,
};
