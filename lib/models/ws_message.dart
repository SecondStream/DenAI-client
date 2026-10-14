import 'package:den_ai/models/models.dart';

class WSMessageError {
  final String status;
  final String message;
  WSMessageError({required this.status, required this.message});
}

class WSMessageChat {
  final Char char;
  final String message;
  WSMessageChat({required this.char, required this.message});
}

enum WSType { error, message }
