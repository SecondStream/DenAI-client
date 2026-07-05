import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'stream_message.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StreamMessage {
  final int chatId;
  final String token;
  final String model;
  final MessageStatus status;

  StreamMessage({
    required this.chatId,
    required this.token,
    required this.model,
    required this.status,
  });

  factory StreamMessage.fromJson(Map<String, dynamic> json) => _$StreamMessageFromJson(json);
  Map<String, dynamic> toJson() => _$StreamMessageToJson(this);
}

enum MessageStatus { thinking, typing, completed, error }

class StreamMessageError {
  final int chatId;
  final String? lastUserMessage;
  final File? imageFile;

  StreamMessageError({required this.chatId, this.lastUserMessage, this.imageFile});
}
