part of 'notify_bloc.dart';

abstract class NotifyState {}

class NotifyInitialState extends NotifyState {}

class NotifyShowErrorState extends NotifyState {
  final ErrType type;

  NotifyShowErrorState({required this.type});
}

class NotifyShowChatState extends NotifyState {
  final Char char;
  final String message;

  NotifyShowChatState({required this.char, required this.message});
}
