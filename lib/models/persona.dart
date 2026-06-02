import 'dart:convert';

import 'package:den_ai/models/crop_data.dart';

abstract class Persona {
  final int id;
  final String name;
  final String avatar;
  final String? crop;

  Persona({required this.id, required this.name, required this.avatar, required this.crop});

  String? getAvatar(String baseUrl) =>
      avatar.isNotEmpty && !avatar.contains('default') ? '$baseUrl/$avatar' : null;

  CropData? getCropData() {
    final crop = this.crop;
    if (crop == null || crop.isEmpty) return null;
    final validJson = crop.replaceAll("'", '"');
    final Map<String, dynamic> map = jsonDecode(validJson);
    return CropData.fromJson(map);
  }
}
