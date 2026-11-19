import 'package:den_ai/repositories/database.dart' show StatisticsData;
import 'package:drift/drift.dart';

enum StatEventType { appLaunchCount }

class Statistic {
  final Map<StatEventType, StatEvent> _statEvents;

  int get appLaunchCount => _getInt(StatEventType.appLaunchCount);

  Statistic._(this._statEvents);
  factory Statistic.fromDb(List<StatisticsData> data) {
    return Statistic._({
      for (final e in data) e.eventType: StatEvent.fromDb(e),
    });
  }

  factory Statistic.empty() => Statistic._(const {});

  int _getInt(StatEventType type, [int fallback = 0]) =>
      int.tryParse(_statEvents[type]?.payload ?? '') ?? fallback;
}


class StatEvent {
  final StatEventType type;
  final String payload;
  DateTime updatedAt;

  StatEvent._({required this.type, required this.payload, required this.updatedAt});

  factory StatEvent.fromDb(StatisticsData data) {
    return StatEvent._(type: data.eventType, payload: data.payload, updatedAt: data.updatedAt);
  }
}

@DataClassName('StatisticsData')
class Statistics extends Table {
  TextColumn get eventType => textEnum<StatEventType>()();
  TextColumn get payload => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {eventType};
}
