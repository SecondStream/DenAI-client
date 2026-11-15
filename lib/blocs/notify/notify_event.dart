part of 'notify_bloc.dart';

abstract class NotifyEvent {}

class ErrorOccurredEvent extends NotifyEvent {
  final ErrType type;
  final Object? error;
  final StackTrace? stackTrace;

  ErrorOccurredEvent({required this.type, required this.error, this.stackTrace}) {
    AppLogger.error('ErrorOccurredEvent: ${type.name}', error: error, stackTrace: stackTrace);
  }
}

class ChatReceivedNotifyEvent extends NotifyEvent {
  final WSMessageChat message;

  ChatReceivedNotifyEvent({required this.message});
}
