part of 'notify_bloc.dart';

abstract class NotifyEvent {}

class ErrorReceivedNotifyEvent extends NotifyEvent {
  final WSMessageError message;

  ErrorReceivedNotifyEvent({required this.message});
}

class ChatReceivedNotifyEvent extends NotifyEvent {
  final WSMessageChat message;

  ChatReceivedNotifyEvent({required this.message});
}
