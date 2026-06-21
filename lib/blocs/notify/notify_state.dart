part of 'notify_bloc.dart';

abstract class NotifyState {}

class NotifyInitialState extends NotifyState {}

class NotifyShowErrorState extends NotifyState {
  final String error;

  NotifyShowErrorState({required this.error});
}

class NotifyShowChatState extends NotifyState {
  final Char char;
  final String message;

  NotifyShowChatState({required this.char, required this.message});
}
