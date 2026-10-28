part of 'notify_bloc.dart';

abstract class NotifyEvent {}

class ErrorOccurredEvent extends NotifyEvent {
  final ErrType type;

  ErrorOccurredEvent({required this.type});
}

class ChatReceivedNotifyEvent extends NotifyEvent {
  final WSMessageChat message;

  ChatReceivedNotifyEvent({required this.message});
}
