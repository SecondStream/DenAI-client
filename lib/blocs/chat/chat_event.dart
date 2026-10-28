part of 'chat_bloc.dart';

abstract class ChatEvent {}

class ShownChatEvent extends ChatEvent {
  final int? chatId;
  final int charId;

  ShownChatEvent({required this.chatId, required this.charId});
}

class UpdateCharacterEvent extends ChatEvent {
  UpdateCharacterEvent();
}

class SendUserMessageEvent extends ChatEvent {
  final String text;
  final bool loreActive;

  SendUserMessageEvent(this.text, this.loreActive);
}

class ReceivedAiTokenEvent extends ChatEvent {
  final StreamMessage message;
  ReceivedAiTokenEvent(this.message);
}

class ReceivedAiTokenErrorEvent extends ChatEvent {
  final StreamMessageError error;
  ReceivedAiTokenErrorEvent(this.error);
}

class RequestUserCardsForDialogEvent extends ChatEvent {
  RequestUserCardsForDialogEvent();
}

class ChangeUserCardEvent extends ChatEvent {
  final int cardId;
  ChangeUserCardEvent(this.cardId);
}

class StartNewChatSessionEvent extends ChatEvent {
  final bool shouldDeleteCurrent;
  StartNewChatSessionEvent(this.shouldDeleteCurrent);
}

class SwitchMessageBranchEvent extends ChatEvent {
  final int messageId;
  final MessageDirection direction;

  SwitchMessageBranchEvent({required this.messageId, required this.direction});
}

class RegenerateLastAiMessageEvent extends ChatEvent {
  final int messageId;
  final bool loreActive;

  RegenerateLastAiMessageEvent(this.messageId, this.loreActive);
}

class EditMessageEvent extends ChatEvent {
  final int messageId;
  final String newContent;
  EditMessageEvent({required this.messageId, required this.newContent});
}

class DeleteMessageEvent extends ChatEvent {
  final int messageId;
  DeleteMessageEvent({required this.messageId});
}

class UpdateChatSummaryEvent extends ChatEvent {
  final String newSummary;
  UpdateChatSummaryEvent({required this.newSummary});
}

class SelectImageEvent extends ChatEvent {
  final File? fileImage;
  SelectImageEvent(this.fileImage);
}
