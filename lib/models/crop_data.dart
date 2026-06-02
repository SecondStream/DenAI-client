import 'package:json_annotation/json_annotation.dart';

part 'crop_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CropData {
  final double l;
  final double t;
  final double w;
  final double h;

  const CropData({required this.l, required this.t, required this.w, required this.h});

  factory CropData.fromJson(Map<String, dynamic> json) => _$CropDataFromJson(json);
  Map<String, dynamic> toJson() => _$CropDataToJson(this);
}
