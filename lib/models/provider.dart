import 'package:den_ai/repositories/database.dart' show ProviderData;
import 'package:drift/drift.dart';

class Provider {
  final int id;
  final String name;
  final String url;
  final String key;

  Provider({required this.id, required this.name, required this.url, required this.key});

  factory Provider.fromDb(ProviderData data) {
    return Provider(id: data.id, name: data.name, url: data.url, key: data.key);
  }
}

class ProviderIn {
  final int? id;
  final String name;
  final String url;
  final String key;

  ProviderIn({required this.id, required this.name, required this.url, required this.key});
}

@DataClassName('ProviderData')
class Providers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get url => text()();
  TextColumn get key => text()();
}
