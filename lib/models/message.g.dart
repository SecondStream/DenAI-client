// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  id: (json['id'] as num).toInt(),
  role: json['role'] as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  currentIndex: (json['current_index'] as num?)?.toInt() ?? 1,
  totalVariants: (json['total_variants'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'id': instance.id,
  'role': instance.role,
  'content': instance.content,
  'created_at': instance.createdAt.toIso8601String(),
  'current_index': instance.currentIndex,
  'total_variants': instance.totalVariants,
};
