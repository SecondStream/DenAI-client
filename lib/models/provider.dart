import 'package:den_ai/repositories/database.dart' show ProviderData;
import 'package:drift/drift.dart';

class Provider {
  final int id;
  final String name;
  final String url;
  final String key;
  final String additionalArgs;

  Provider._({
    required this.id,
    required this.name,
    required this.url,
    required this.key,
    this.additionalArgs = '',
  });

  factory Provider.fromDb(ProviderData data, String key) {
    return Provider._(
      id: data.id,
      name: data.name,
      url: data.url,
      key: key,
      additionalArgs: data.additionalArgs,
    );
  }
}

class ProviderIn {
  final int? id;
  final String name;
  final String url;
  final String key;
  final String additionalArgs;

  ProviderIn({
    required this.id,
    required this.name,
    required this.url,
    required this.key,
    required this.additionalArgs,
  });
}

@DataClassName('ProviderData')
class Providers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get url => text()();
  TextColumn get additionalArgs => text().withDefault(const Constant(''))();
}
