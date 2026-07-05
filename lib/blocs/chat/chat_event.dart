part of 'chat_bloc.dart';

abstract class ChatEvent {}

class LoadChatHistoryEvent extends ChatEvent {
  final int chatId;
  LoadChatHistoryEvent(this.chatId);
}

class UpdateCharacterEvent extends ChatEvent {
  UpdateCharacterEvent();
}

class CheckOrCreateVirtualChatEvent extends ChatEvent {
  final int charId;
  CheckOrCreateVirtualChatEvent(this.charId);
}

class SendUserMessageEvent extends ChatEvent {
  final String text;

  SendUserMessageEvent(this.text);
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

class RegenerateLastAiMessageEvent extends ChatEvent {}

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
