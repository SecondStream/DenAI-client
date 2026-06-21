// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllSettings _$AllSettingsFromJson(Map<String, dynamic> json) => AllSettings(
  models: (json['models'] as List<dynamic>)
      .map((e) => ModelInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  visionModels: (json['vision_models'] as List<dynamic>)
      .map((e) => ModelInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  tokenizers: (json['tokenizers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  settings: SettingsBase.fromJson(json['settings'] as Map<String, dynamic>),
  providers: (json['providers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$AllSettingsToJson(AllSettings instance) =>
    <String, dynamic>{
      'models': instance.models,
      'vision_models': instance.visionModels,
      'tokenizers': instance.tokenizers,
      'settings': instance.settings,
      'providers': instance.providers,
    };
