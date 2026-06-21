// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSMessageError _$WSMessageErrorFromJson(Map<String, dynamic> json) =>
    WSMessageError(
      status: json['status'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$WSMessageErrorToJson(WSMessageError instance) =>
    <String, dynamic>{'status': instance.status, 'message': instance.message};

WSMessageChat _$WSMessageChatFromJson(Map<String, dynamic> json) =>
    WSMessageChat(
      char: Char.fromJson(json['char'] as Map<String, dynamic>),
      message: json['message'] as String,
    );

Map<String, dynamic> _$WSMessageChatToJson(WSMessageChat instance) =>
    <String, dynamic>{'char': instance.char, 'message': instance.message};
