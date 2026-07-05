// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamMessage _$StreamMessageFromJson(Map<String, dynamic> json) =>
    StreamMessage(
      chatId: (json['chat_id'] as num).toInt(),
      token: json['token'] as String,
      model: json['model'] as String,
      status: $enumDecode(_$MessageStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$StreamMessageToJson(StreamMessage instance) =>
    <String, dynamic>{
      'chat_id': instance.chatId,
      'token': instance.token,
      'model': instance.model,
      'status': _$MessageStatusEnumMap[instance.status]!,
    };

const _$MessageStatusEnumMap = {
  MessageStatus.thinking: 'thinking',
  MessageStatus.typing: 'typing',
  MessageStatus.completed: 'completed',
  MessageStatus.error: 'error',
};
