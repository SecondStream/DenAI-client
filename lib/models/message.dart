import 'package:den_ai/models/chat.dart';
import 'package:den_ai/repositories/database.dart' show MessageData;
import 'package:drift/drift.dart';

enum MessageRole { assistant, user }

enum MessageDirection { left, right }

class Message {
  final int id;
  final MessageRole role;
  final String content;
  final DateTime createdAt;
  final String? imagePath;
  final String modelName;
  final int? parentId;
  final bool isActive;

  Message({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.parentId,
    this.imagePath,
    this.modelName = '',
    this.isActive = true,
  });

  factory Message.fromDb(MessageData data) {
    return Message(
      id: data.id,
      role: data.role,
      content: data.content,
      createdAt: data.createdAt,
      imagePath: data.imagePath,
      modelName: data.modelName,
      parentId: data.parentId,
      isActive: data.isActive,
    );
  }

  Message copyWith({String? content, String? modelName}) {
    return Message(
      id: id,
      role: role,
      content: content ?? this.content,
      createdAt: createdAt,
      imagePath: imagePath,
      modelName: modelName ?? this.modelName,
      parentId: parentId,
      isActive: isActive,
    );
  }
}

@DataClassName('MessageData')
class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chatId => integer().references(Chats, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => textEnum<MessageRole>()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get parentId => integer().nullable()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get modelName => text().withDefault(const Constant(''))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
