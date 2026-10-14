import 'dart:io';

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
}

enum MessageStatus { thinking, typing, completed, error }

class StreamMessageError {
  final int chatId;
  final String? lastUserMessage;
  final File? imageFile;

  StreamMessageError({required this.chatId, this.lastUserMessage, this.imageFile});
}
