import 'package:den_ai/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_message.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WSMessageError {
  final String status;
  final String message;

  factory WSMessageError.fromJson(Map<String, dynamic> json) => _$WSMessageErrorFromJson(json);

  WSMessageError({required this.status, required this.message});

  Map<String, dynamic> toJson() => _$WSMessageErrorToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WSMessageChat {
  final Char char;
  final String message;

  factory WSMessageChat.fromJson(Map<String, dynamic> json) => _$WSMessageChatFromJson(json);

  WSMessageChat({required this.char, required this.message});

  Map<String, dynamic> toJson() => _$WSMessageChatToJson(this);
}

enum WSType { error, message }
