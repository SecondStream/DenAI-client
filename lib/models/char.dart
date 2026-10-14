import 'dart:convert';
import 'package:den_ai/models/crop_data.dart';
import 'package:den_ai/models/persona.dart';
import 'package:den_ai/repositories/database.dart' show CharData;
import 'package:drift/drift.dart';
import 'lorebook.dart';
import 'package:path/path.dart' as p;

class Char extends Persona {
  final int id;
  final String name;
  final String? avatar;
  final String? crop;
  final String? background;
  final String appearance;
  final String personality;
  final String scenario;
  final String greeting;
  final String prompt;
  final List<Lorebook> lorebooks;

  Char({
    required this.id,
    required this.name,
    this.avatar,
    this.crop,
    this.background,
    this.appearance = "",
    this.personality = "",
    this.scenario = "",
    this.greeting = "",
    this.prompt = "",
    required this.lorebooks,
  });

  factory Char.fromDb(CharData data, {required List<Lorebook> lorebooks}) {
    return Char(
      id: data.id,
      name: data.name,
      avatar: data.avatar,
      crop: data.crop,
      background: data.background,
      appearance: data.appearance,
      personality: data.personality,
      scenario: data.scenario,
      greeting: data.greeting,
      prompt: data.prompt,
      lorebooks: lorebooks,
    );
  }

  @override
  String? getAvatar(String baseUrl) =>
      avatar != null && avatar!.isNotEmpty && !avatar!.contains('default')
      ? p.join(baseUrl, avatar)
      : null;

  String? getBackground(String baseUrl) =>
      background != null && background!.isNotEmpty ? p.join(baseUrl, background) : null;

  @override
  CropData? getCropData() {
    if (crop == null || crop!.isEmpty) return null;
    final validJson = crop!.replaceAll("'", '"');
    final Map<String, dynamic> map = jsonDecode(validJson);
    return CropData.fromJson(map);
  }
}

@DataClassName('CharData')
class Chars extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get avatar => text().nullable()();
  TextColumn get crop => text().nullable()();
  TextColumn get background => text().nullable()();

  TextColumn get appearance => text().withDefault(const Constant(''))();
  TextColumn get personality => text().withDefault(const Constant(''))();
  TextColumn get scenario => text().withDefault(const Constant(''))();
  TextColumn get greeting => text().withDefault(const Constant(''))();
  TextColumn get prompt => text().withDefault(const Constant(''))();
}
