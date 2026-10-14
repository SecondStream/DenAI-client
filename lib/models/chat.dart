import 'package:den_ai/models/summary.dart';
import 'package:den_ai/repositories/database.dart' show ChatData;
import 'package:drift/drift.dart';
import 'char.dart';
import 'user_card.dart';
import 'message.dart';

class Chat {
  final int id;
  final String title;
  final Char char;
  final List<Message> messages;
  final String? background;
  final UserCard? userCard;
  final List<Summary> summaries;
  final DateTime createdAt;

  Chat({
    required this.id,
    required this.title,
    required this.char,
    required this.messages,
    required this.summaries,
    required this.createdAt,
    this.background,
    this.userCard,
  });

  factory Chat.fromDb(
    ChatData data, {
    required Char char,
    required List<Message> messages,
    UserCard? userCard,
    List<Summary> summaries = const [],
  }) {
    return Chat(
      id: data.id,
      title: data.title,
      char: char,
      messages: messages,
      summaries: summaries,
      userCard: userCard,
      background: data.background,
      createdAt: data.createdAt,
    );
  }

  String? getBackground(String baseUrl) =>
      background != null && background!.isNotEmpty ? '$baseUrl/$background' : null;
}

@DataClassName('ChatData')
class Chats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get charId => integer().references(Chars, #id, onDelete: KeyAction.cascade)();
  IntColumn get userCardId =>
      integer().nullable().references(UserCards, #id, onDelete: KeyAction.setNull)();

  TextColumn get background => text().nullable()();
}
