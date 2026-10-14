import 'package:den_ai/models/models.dart';

class AllSettings {
  final List<ModelInfo> models;
  final List<ModelInfo> visionModels;
  final List<String> tokenizers;
  final SettingsBase settings;
  final List<String> providers;

  AllSettings({
    required this.models,
    required this.visionModels,
    required this.tokenizers,
    required this.settings,
    required this.providers,
  });
}
