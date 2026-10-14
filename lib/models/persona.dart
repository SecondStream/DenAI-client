import 'package:den_ai/models/crop_data.dart';

abstract class Persona {
  Persona();

  String? getAvatar(String baseUrl);

  CropData? getCropData();
}
