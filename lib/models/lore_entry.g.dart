// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lore_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoreEntry _$LoreEntryFromJson(Map<String, dynamic> json) => LoreEntry(
  id: (json['id'] as num).toInt(),
  lorebookId: (json['lorebook_id'] as num).toInt(),
  title: json['title'] as String,
  content: json['content'] as String? ?? '',
);

Map<String, dynamic> _$LoreEntryToJson(LoreEntry instance) => <String, dynamic>{
  'id': instance.id,
  'lorebook_id': instance.lorebookId,
  'title': instance.title,
  'content': instance.content,
};

LoreEntryIn _$LoreEntryInFromJson(Map<String, dynamic> json) => LoreEntryIn(
  id: (json['id'] as num?)?.toInt(),
  lorebookId: (json['lorebook_id'] as num).toInt(),
  title: json['title'] as String,
  content: json['content'] as String? ?? '',
);

Map<String, dynamic> _$LoreEntryInToJson(LoreEntryIn instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lorebook_id': instance.lorebookId,
      'title': instance.title,
      'content': instance.content,
    };
