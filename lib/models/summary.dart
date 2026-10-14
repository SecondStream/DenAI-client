import 'package:den_ai/models/chat.dart';
import 'package:drift/drift.dart';

class Summary {
  final int id;
  final int chatId;
  final String content;
  final int lastSummarizedMessageId;
  final DateTime createdAt;

  Summary({
    required this.id,
    required this.chatId,
    this.content = "",
    required this.lastSummarizedMessageId,
    required this.createdAt,
  });
}

@DataClassName('SummaryData')
class Summaries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get chatId => integer().references(Chats, #id, onDelete: KeyAction.cascade)();

  TextColumn get content => text().withDefault(const Constant(''))();
  IntColumn get lastSummarizedMessageId => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
