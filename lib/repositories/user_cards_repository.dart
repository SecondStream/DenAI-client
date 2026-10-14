import 'dart:async';
import 'dart:convert';

import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/base_repository.dart';
import 'package:den_ai/repositories/database.dart' show UserCardsCompanion, UserCardData;
import 'package:drift/drift.dart' show Value, countAll, OrderingMode, OrderingTerm;

class UserCardsRepository extends BaseRepository {
  UserCardsRepository(super.db);

  Future<List<UserCard>> getUserCards() async {
    final List<UserCardData> rows = await (db.select(
      db.userCards,
    )..where((tbl) => tbl.isRemoved.equals(false))).get();

    return rows.map((row) => UserCard.fromDb(row)).toList();
  }

  Future<UserCard?> getDefaultUserCard() async {
    // SELECT * FROM user_cards WHERE is_default = true AND is_removed = false LIMIT 1
    final row =
        await (db.select(db.userCards)
              ..where((tbl) => tbl.isDefault.equals(true))
              ..where((tbl) => tbl.isRemoved.equals(false)))
            .getSingleOrNull();

    if (row == null) return null;
    return UserCard.fromDb(row);
  }

  Future<void> deleteUserCard(int id) async {
    await db.transaction(() async {
      final targetCard = await (db.select(
        db.userCards,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

      if (targetCard == null) return;

      // UPDATE user_cards SET is_removed = true WHERE id = :id
      final removeCompanion = const UserCardsCompanion(isRemoved: Value(true));
      await (db.update(db.userCards)..where((tbl) => tbl.id.equals(id))).write(removeCompanion);

      if (targetCard.isDefault) {
        final resetCompanion = const UserCardsCompanion(isDefault: Value(false));
        await (db.update(db.userCards)..where((tbl) => tbl.id.equals(id))).write(resetCompanion);
        final fallbackQuery = db.select(db.userCards)
          ..where((tbl) => tbl.id.isNotValue(id))
          ..where((tbl) => tbl.isRemoved.equals(false))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.id, mode: OrderingMode.desc)])
          ..limit(1);

        final fallbackCard = await fallbackQuery.getSingleOrNull();

        if (fallbackCard != null) {
          final makeDefaultCompanion = const UserCardsCompanion(isDefault: Value(true));
          await (db.update(
            db.userCards,
          )..where((tbl) => tbl.id.equals(fallbackCard.id))).write(makeDefaultCompanion);
        }
      }
    });
  }

  Future<UserCard> saveUserCard({
    int? id,
    required String name,
    required String description,
    bool isDefault = false,
    String? avatarPath,
    CropData? cropData,
  }) async {
    bool finalIsDefault = isDefault;
    final String? cropString = cropData != null ? jsonEncode(cropData.toJson()) : null;
    int finalId;

    return await db.transaction(() async {
      if (!finalIsDefault) {
        final countAmount = countAll();
        final countQuery = db.selectOnly(db.userCards)
          ..addColumns([countAmount])
          ..where(db.userCards.isRemoved.equals(false));

        final int cardsCount =
            await countQuery.map((row) => row.read<int>(countAmount)).getSingle() ?? 0;
        if (cardsCount == 0) finalIsDefault = true;
      }

      if (finalIsDefault) {
        final resetCompanion = const UserCardsCompanion(isDefault: Value(false));
        await (db.update(
          db.userCards,
        )..where((tbl) => tbl.isDefault.equals(true))).write(resetCompanion);
      }

      if (id != null && id > 0) {
        finalId = id;
        final companion = UserCardsCompanion(
          name: Value(name),
          description: Value(description),
          isDefault: Value(finalIsDefault),
          crop: cropString != null ? Value(cropString) : const Value.absent(),
          avatar: avatarPath != null ? Value(avatarPath) : const Value.absent(),
        );
        await (db.update(db.userCards)..where((tbl) => tbl.id.equals(id))).write(companion);
      } else {
        final finalAvatar = avatarPath ?? "assets/avatars/default_user.png";
        final companion = UserCardsCompanion.insert(
          name: name,
          description: Value(description),
          isDefault: Value(finalIsDefault),
          avatar: Value(finalAvatar),
          crop: Value(cropString),
        );
        finalId = await db.into(db.userCards).insert(companion);
      }

      final cardRow = await (db.select(
        db.userCards,
      )..where((tbl) => tbl.id.equals(finalId))).getSingle();
      return UserCard.fromDb(cardRow);
    });
  }
}
