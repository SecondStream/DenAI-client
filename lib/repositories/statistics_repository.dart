import 'package:den_ai/repositories/base_repository.dart';

import 'package:den_ai/models/models.dart';
import 'package:drift/drift.dart';

import 'database.dart';

class StatisticsRepository extends BaseRepository {

  StatisticsRepository(super.db);

  Future<Statistic> getAll() async {
    final rows = await db.select(db.statistics).get();
    return Statistic.fromDb(rows);
  }

  Future<Statistic> setValue(StatEventType type, String value) async {
    await db.into(db.statistics).insertOnConflictUpdate(
      StatisticsCompanion.insert(
        eventType: type,
        payload: value,
        updatedAt: Value(DateTime.now()),
      ),
    );
    return getAll();
  }

  Future<Statistic> increment(StatEventType type, [int step = 1]) async {
    final now = DateTime.now();
    await db.into(db.statistics).insert(
      StatisticsCompanion.insert(
        eventType: type,
        payload: '$step',
        updatedAt: Value(now),
      ),
      onConflict: DoUpdate(
            (old) => StatisticsCompanion.custom(
          payload: CustomExpression<String>(
            'CAST(CAST(payload AS INTEGER) + $step AS TEXT)',
          ),
          updatedAt: Variable(now),
        ),
      ),
    );
    return getAll();
  }

  Future<Statistic> reset(StatEventType type) async {
    await (db.delete(db.statistics)
      ..where((t) => t.eventType.equalsValue(type)))
        .go();
    return getAll();
  }

  Future<Statistic> clearAll() async {
    await db.delete(db.statistics).go();
    return Statistic.fromDb(const []);
  }
}
