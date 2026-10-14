import 'dart:convert';
import 'package:den_ai/models/crop_data.dart';
import 'package:den_ai/models/persona.dart';
import 'package:den_ai/repositories/database.dart' show UserCardData;
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

class UserCard extends Persona {
  final int id;
  final String name;
  final String? avatar;
  final String? crop;
  final String description;
  final bool isDefault;
  final bool isRemoved;

  UserCard({
    required this.id,
    required this.name,
    required this.avatar,
    this.crop,
    this.description = "",
    this.isDefault = false,
    this.isRemoved = false,
  });

  factory UserCard.fromDb(UserCardData data) {
    return UserCard(
      id: data.id,
      name: data.name,
      avatar: data.avatar,
      crop: data.crop,
      description: data.description,
      isDefault: data.isDefault,
    );
  }

  @override
  String? getAvatar(String baseUrl) =>
      avatar != null && avatar!.isNotEmpty && !avatar!.contains('default')
      ? p.join(baseUrl, avatar)
      : null;

  @override
  CropData? getCropData() {
    if (crop == null || crop!.isEmpty) return null;
    final validJson = crop!.replaceAll("'", '"');
    final Map<String, dynamic> map = jsonDecode(validJson);
    return CropData.fromJson(map);
  }
}

@DataClassName('UserCardData')
class UserCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get avatar => text().nullable()();
  TextColumn get crop => text().nullable()();

  TextColumn get description => text().withDefault(const Constant(''))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  BoolColumn get isRemoved => boolean().withDefault(const Constant(false))();
}
