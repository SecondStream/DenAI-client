import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:den_ai/consts/consts.dart';
import 'package:den_ai/repositories/base_repository.dart';
import 'package:den_ai/repositories/database.dart';
import 'package:drift/drift.dart'
    show
        ComparableExpr,
        CustomExpression,
        OrderingMode,
        OrderingTerm,
        TypedResult,
        Value,
        innerJoin,
        leftOuterJoin,
        Expression;

import '../models/models.dart';

class ChatsRepository extends BaseRepository {
  final _messageController = StreamController<StreamMessage>.broadcast();
  Stream<StreamMessage> get allMessagesStream => _messageController.stream;

  ChatsRepository(super.db);

  Future<List<Chat>> getChats() async {
    final latestAmount = CustomExpression<int>('MAX(id)');

    final latestMessageIdQuery = db.selectOnly(db.messages)
      ..addColumns([latestAmount])
      ..where(db.messages.isActive.equals(true))
      ..groupBy([db.messages.chatId]);

    final List<int> latestMessageIds =
        (await latestMessageIdQuery.map((row) => row.read<int>(latestAmount)).get())
            .whereType<int>()
            .toList();

    final query = db.select(db.chats).join([
      leftOuterJoin(db.chars, db.chars.id.equalsExp(db.chats.charId)),
      leftOuterJoin(
        db.messages,
        Expression.and([
          db.messages.id.isIn(latestMessageIds),
          db.messages.chatId.equalsExp(db.chats.id),
        ]),
      ),
    ]);

    final List<TypedResult> rows = await query.get();
    final List<Chat> chatList = <Chat>[];

    for (final row in rows) {
      final chatData = row.readTable(db.chats);
      final charData = row.readTableOrNull(db.chars);
      final messageData = row.readTableOrNull(db.messages);

      if (charData == null) continue;

      final finalChar = Char.fromDb(charData, lorebooks: const <Lorebook>[]);

      final List<Message> messagesResult = <Message>[];
      if (messageData != null) {
        messagesResult.add(Message.fromDb(messageData));
      }

      chatList.add(
        Chat.fromDb(chatData, char: finalChar, messages: messagesResult, userCard: null),
      );
    }

    chatList.sort((a, b) {
      final DateTime dateA = a.messages.isNotEmpty ? a.messages.first.createdAt : a.createdAt;
      final DateTime dateB = b.messages.isNotEmpty ? b.messages.first.createdAt : b.createdAt;
      return dateB.compareTo(dateA);
    });

    return chatList;
  }

  Future<Chat> getChatById(int chatId) async {
    return await db.transaction(() async {
      final chatQuery = db.select(db.chats).join([
        leftOuterJoin(db.userCards, db.userCards.id.equalsExp(db.chats.userCardId)),
      ])..where(db.chats.id.equals(chatId));

      final chatRows = await chatQuery.get();
      if (chatRows.isEmpty) {
        throw StateError('Chat not found');
      }

      final chatRow = chatRows.first;
      final chatData = chatRow.readTable(db.chats);
      final userCardData = chatRow.readTableOrNull(db.userCards);
      final finalUserCard = userCardData != null ? UserCard.fromDb(userCardData) : null;

      final charQuery =
          db.select(db.chars).join([
              leftOuterJoin(db.charLorebooks, db.charLorebooks.charId.equalsExp(db.chars.id)),
              leftOuterJoin(db.lorebooks, db.lorebooks.id.equalsExp(db.charLorebooks.lorebookId)),
              leftOuterJoin(db.loreEntries, db.loreEntries.lorebookId.equalsExp(db.lorebooks.id)),
            ])
            ..where(db.chars.id.equals(chatData.charId))
            ..orderBy([OrderingTerm.asc(db.loreEntries.id)]);

      final charRows = await charQuery.get();
      if (charRows.isEmpty) {
        throw StateError('Character not found');
      }

      final charDataObj = charRows.first.readTable(db.chars);
      final Map<int, LorebookData> uniqueBooks = {};
      final Map<int, List<LoreEntry>> bookEntries = {};

      for (final row in charRows) {
        final bookData = row.readTableOrNull(db.lorebooks);
        final entryData = row.readTableOrNull(db.loreEntries);

        if (bookData != null) {
          uniqueBooks[bookData.id] = bookData;
          if (entryData != null) {
            final entriesList = bookEntries.putIfAbsent(bookData.id, () => <LoreEntry>[]);
            if (!entriesList.any((e) => e.id == entryData.id)) {
              entriesList.add(
                LoreEntry(
                  id: entryData.id,
                  lorebookId: entryData.lorebookId,
                  title: entryData.title,
                  content: entryData.content,
                ),
              );
            }
          }
        }
      }

      final List<Lorebook> finalLorebooks = uniqueBooks.values.map((bData) {
        return Lorebook(
          id: bData.id,
          name: bData.name,
          about: bData.about,
          cover: bData.cover,
          crop: bData.crop,
          entries: bookEntries[bData.id] ?? <LoreEntry>[],
        );
      }).toList();

      final finalChar = Char.fromDb(charDataObj, lorebooks: finalLorebooks);

      final List<MessageData> messageRows =
          await (db.select(db.messages)
                ..where((tbl) => tbl.chatId.equals(chatId))
                ..orderBy([
                  (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.asc),
                ]))
              .get();

      final List<Message> finalMessages = messageRows.map((row) => Message.fromDb(row)).toList();

      final List<SummaryData> summaryRows =
          await (db.select(db.summaries)
                ..where((tbl) => tbl.chatId.equals(chatId))
                ..orderBy([
                  (tbl) =>
                      OrderingTerm(expression: tbl.lastSummarizedMessageId, mode: OrderingMode.asc),
                ]))
              .get();

      final List<Summary> finalSummaries = summaryRows.map((row) {
        return Summary(
          id: row.id,
          chatId: row.chatId,
          content: row.content,
          lastSummarizedMessageId: row.lastSummarizedMessageId,
          createdAt: row.createdAt,
        );
      }).toList();

      return Chat.fromDb(
        chatData,
        char: finalChar,
        messages: finalMessages,
        userCard: finalUserCard,
        summaries: finalSummaries,
      );
    });
  }

  Future<Chat?> getActiveChatByCharId(int charId) async {
    final latestMessageQuery =
        db.select(db.messages).join([
            innerJoin(db.chats, db.chats.id.equalsExp(db.messages.chatId)),
          ])
          ..where(db.chats.charId.equals(charId))
          ..orderBy([OrderingTerm(expression: db.messages.createdAt, mode: OrderingMode.desc)])
          ..limit(1);

    final List<TypedResult> messageRows = await latestMessageQuery.get();

    if (messageRows.isNotEmpty) {
      final int activeChatId = messageRows.first.readTable(db.messages).chatId;
      return await getChatById(activeChatId);
    }

    final latestChatRow =
        await (db.select(db.chats)
              ..where((tbl) => tbl.charId.equals(charId))
              ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)])
              ..limit(1))
            .getSingleOrNull();

    if (latestChatRow != null) {
      return await getChatById(latestChatRow.id);
    }

    return null;
  }

  Future<Chat> switchMessageBranch(int messageId, MessageDirection direction) async {
    return await db.transaction(() async {
      final currentMsg = await (db.select(
        db.messages,
      )..where((tbl) => tbl.id.equals(messageId))).getSingleOrNull();
      if (currentMsg == null || currentMsg.role != MessageRole.assistant) {
        throw ArgumentError('Invalid message id');
      }

      final allChatMessages = await (db.select(
        db.messages,
      )..where((tbl) => tbl.chatId.equals(currentMsg.chatId))).get();

      final List<MessageData> variants = allChatMessages.where((m) {
        return m.role == MessageRole.assistant && m.parentId == currentMsg.parentId;
      }).toList();

      if (variants.length <= 1) {
        return await getChatById(currentMsg.chatId);
      }

      final int currentIndex = variants.indexWhere((m) => m.id == currentMsg.id);
      if (currentIndex == -1) {
        return await getChatById(currentMsg.chatId);
      }

      int nextIndex;
      if (direction == MessageDirection.left) {
        nextIndex = currentIndex - 1;
        if (nextIndex < 0) {
          nextIndex = variants.length - 1;
        }
      } else {
        nextIndex = currentIndex + 1;
        if (nextIndex >= variants.length) {
          nextIndex = 0;
        }
      }

      await (db.update(db.messages)..where((tbl) => tbl.id.equals(currentMsg.id))).write(
        const MessagesCompanion(isActive: Value(false)),
      );

      final targetMsg = variants[nextIndex];
      await (db.update(db.messages)..where((tbl) => tbl.id.equals(targetMsg.id))).write(
        const MessagesCompanion(isActive: Value(true)),
      );

      return await getChatById(currentMsg.chatId);
    });
  }

  Future<Chat> editMessage(int messageId, String newContent) async {
    return await db.transaction(() async {
      final msg = await (db.select(
        db.messages,
      )..where((tbl) => tbl.id.equals(messageId))).getSingleOrNull();
      if (msg == null) {
        throw StateError('Message not found');
      }

      final String oldContent = msg.content;
      String processedContent = newContent;
      String? updatedImagePath = msg.imagePath;

      if (msg.imagePath != null) {
        if (processedContent.contains(MessageTags.img)) {
          final int startIdx = oldContent.indexOf(MessageTags.imgXmlStart);
          final int endIdx = oldContent.indexOf(MessageTags.imgXmlEnd);

          if (startIdx != -1 && endIdx != -1) {
            final String xmlTag = oldContent.substring(
              startIdx,
              endIdx + '</attached_image>'.length,
            );
            processedContent = processedContent.replaceAll(MessageTags.img, xmlTag);
          }
        } else {
          updatedImagePath = null;
        }
      }

      final companion = MessagesCompanion(
        content: Value(processedContent),
        imagePath: Value(updatedImagePath),
      );

      await (db.update(db.messages)..where((tbl) => tbl.id.equals(messageId))).write(companion);

      return await getChatById(msg.chatId);
    });
  }

  Future<Chat> deleteMessage(int messageId) async {
    return await db.transaction(() async {
      final msg = await (db.select(
        db.messages,
      )..where((tbl) => tbl.id.equals(messageId))).getSingleOrNull();
      if (msg == null) {
        throw StateError('Message not found');
      }

      final int chatConvertId = msg.chatId;

      await (db.delete(db.messages)
            ..where((tbl) => tbl.chatId.equals(chatConvertId))
            ..where((tbl) => tbl.id.isBiggerOrEqualValue(messageId)))
          .go();

      await (db.delete(db.summaries)
            ..where((tbl) => tbl.chatId.equals(chatConvertId))
            ..where((tbl) => tbl.lastSummarizedMessageId.isBiggerOrEqualValue(messageId)))
          .go();

      return await getChatById(chatConvertId);
    });
  }

  Future<void> updateMessageActivity(int messageId, bool isActive) async {
    // UPDATE messages SET is_active = :isActive WHERE id = :messageId
    final companion = MessagesCompanion(isActive: Value(isActive));
    await (db.update(db.messages)..where((tbl) => tbl.id.equals(messageId))).write(companion);
  }

  Future<void> deleteMessageRaw(int messageId) async {
    // DELETE FROM messages WHERE id = :messageId
    await (db.delete(db.messages)..where((tbl) => tbl.id.equals(messageId))).go();
  }

  Future<void> updateChatUserCard(int chatId, int userCardId) async {
    final companion = ChatsCompanion(userCardId: Value(userCardId));

    await (db.update(db.chats)..where((tbl) => tbl.id.equals(chatId))).write(companion);
  }

  // Future<void> regenerateMessage(int chatId) async {
  //   try {
  //     final ResponseBody? r = await remote.post<ResponseBody, Map<String, dynamic>>(
  //       '$endpoint/$chatId/regenerate',
  //       options: Options(responseType: ResponseType.stream),
  //     );

  //     if (r != null) {
  //       final stream = r.stream
  //           .transform(unit8BufferToString)
  //           .transform(const LineSplitter())
  //           .where((line) => line.trim().isNotEmpty) // maybe ping
  //           .map((jsonStr) => StreamMessage.fromJson(jsonDecode(jsonStr)));

  //       await for (final message in stream) {
  //         _messageController.add(message);
  //       }
  //     }
  //   } catch (e) {
  //     _messageController.addError(StreamMessageError(chatId: chatId));
  //   }
  // }

  Future<int> insertMessage({
    required int chatId,
    required MessageRole role,
    required String content,
    int? parentId,
    String? imagePath,
    String? modelName,
  }) async {
    final companion = MessagesCompanion.insert(
      chatId: chatId,
      role: role,
      content: content,
      createdAt: DateTime.now(),
      parentId: Value(parentId),
      imagePath: Value(imagePath),
      modelName: Value(modelName ?? ''),
    );
    return await db.into(db.messages).insert(companion);
  }

  Future<Chat> createNewChat(int charId, int? userCardId) async {
    return await db.transaction(() async {
      final charData = await (db.select(
        db.chars,
      )..where((tbl) => tbl.id.equals(charId))).getSingleOrNull();
      if (charData == null) {
        throw StateError('Character not found');
      }

      UserCardData? userCardData;
      if (userCardId != null && userCardId > 0) {
        userCardData = await (db.select(
          db.userCards,
        )..where((tbl) => tbl.id.equals(userCardId))).getSingleOrNull();
      }

      final chatCompanion = ChatsCompanion.insert(
        title: charData.name,
        charId: charId,
        userCardId: userCardData != null ? Value(userCardData.id) : const Value.absent(),
        background: Value(charData.background),
        createdAt: DateTime.now(),
      );

      final int newChatId = await db.into(db.chats).insert(chatCompanion);
      final List<Message> initialMessages = <Message>[];
      final String trimmedGreeting = charData.greeting.trim();

      if (trimmedGreeting.isNotEmpty) {
        final int messageId = await insertMessage(
          chatId: newChatId,
          role: MessageRole.assistant,
          content: trimmedGreeting,
        );

        initialMessages.add(
          Message(
            id: messageId,
            role: MessageRole.assistant,
            content: trimmedGreeting,
            createdAt: DateTime.now(),
          ),
        );
      }

      final finalChar = Char.fromDb(charData, lorebooks: const <Lorebook>[]);
      final finalUserCard = userCardData != null ? UserCard.fromDb(userCardData) : null;

      return Chat(
        id: newChatId,
        title: charData.name,
        char: finalChar,
        messages: initialMessages,
        summaries: [],
        userCard: finalUserCard,
        background: charData.background,
        createdAt: DateTime.now(),
      );
    });
  }

  // Future<String?> uploadImage(File file) async {
  //   final formData = FormData.fromMap({
  //     'image_file': await MultipartFile.fromFile(
  //       file.path,
  //       filename: file.path.split(Platform.pathSeparator).last,
  //     ),
  //   });

  //   final response = await remote.post("$endpoint/upload-image", data: formData);
  //   return response['image_path'];
  // }

  // Future<void> sendMessage(int chatId, String text, String? imagePath, File? imageFile) async {
  //   try {
  //     final ResponseBody? r = await remote.post<ResponseBody, dynamic>(
  //       '$endpoint/$chatId/send',
  //       data: {"content": text, "image_path": imagePath},
  //       options: Options(responseType: ResponseType.stream),
  //     );

  //     if (r != null) {
  //       final stream = r.stream
  //           .transform(unit8BufferToString)
  //           .transform(const LineSplitter())
  //           .where((line) => line.trim().isNotEmpty) // maybe ping
  //           .map((jsonStr) => StreamMessage.fromJson(jsonDecode(jsonStr)));

  //       await for (final message in stream) {
  //         _messageController.add(message);
  //       }
  //     }
  //   } catch (e) {
  //     _messageController.addError(
  //       StreamMessageError(chatId: chatId, lastUserMessage: text, imageFile: imageFile),
  //     );
  //   }
  // }

  Future<void> deleteChat(int chatId) async {
    await (db.delete(db.chats)..where((tbl) => tbl.id.equals(chatId))).go();
  }

  Future<Chat> updateChatSummary(int chatId, String newSummary) async {
    return await db.transaction(() async {
      final latestSummaryRow =
          await (db.select(db.summaries)
                ..where((tbl) => tbl.chatId.equals(chatId))
                ..orderBy([
                  (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
                ])
                ..limit(1))
              .getSingleOrNull();

      if (latestSummaryRow == null) {
        final companion = SummariesCompanion.insert(
          chatId: chatId,
          content: Value(newSummary),
          lastSummarizedMessageId: 0,
          createdAt: Value(DateTime.now()),
        );
        await db.into(db.summaries).insert(companion);
      } else {
        final companion = SummariesCompanion(content: Value(newSummary));
        await (db.update(
          db.summaries,
        )..where((tbl) => tbl.id.equals(latestSummaryRow.id))).write(companion);
      }

      return await getChatById(chatId);
    });
  }

  Future<void> addSummary(int chatId, int anchorMessageId, String content) async {
    final companion = SummariesCompanion.insert(
      chatId: chatId,
      lastSummarizedMessageId: anchorMessageId,
      content: Value(content),
      createdAt: Value(DateTime.now()),
    );

    await db.into(db.summaries).insert(companion);
  }

  StreamTransformer<Uint8List, String> get unit8BufferToString =>
      StreamTransformer<Uint8List, String>.fromHandlers(
        handleData: (data, sink) {
          sink.add(utf8.decode(data, allowMalformed: true));
        },
      );

  void dispose() {
    _messageController.close();
  }
}
