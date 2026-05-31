// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsBase _$SettingsBaseFromJson(Map<String, dynamic> json) => SettingsBase(
  modelName: json['model_name'] as String,
  visionModelName: json['vision_model_name'] as String,
  tokenizerPath: json['tokenizer_path'] as String,
  maxContextTokens: (json['max_context_tokens'] as num).toInt(),
  temperature: (json['temperature'] as num).toDouble(),
  minP: (json['min_p'] as num).toDouble(),
  topP: (json['top_p'] as num).toDouble(),
  repeatPenalty: (json['repeat_penalty'] as num).toDouble(),
  globalSystemPrompt: json['global_system_prompt'] as String,
);

Map<String, dynamic> _$SettingsBaseToJson(SettingsBase instance) =>
    <String, dynamic>{
      'model_name': instance.modelName,
      'vision_model_name': instance.visionModelName,
      'tokenizer_path': instance.tokenizerPath,
      'max_context_tokens': instance.maxContextTokens,
      'temperature': instance.temperature,
      'min_p': instance.minP,
      'top_p': instance.topP,
      'repeat_penalty': instance.repeatPenalty,
      'global_system_prompt': instance.globalSystemPrompt,
    };
