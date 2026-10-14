import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/base_repository.dart';

class SettingsRepository extends BaseRepository {
  SettingsRepository(super.db);

  Future<AllSettings> getAllSettings() async {
    // TODO
    return AllSettings(
      models: [],
      visionModels: [],
      tokenizers: [],
      settings: SettingsBase(
        modelName: '',
        visionModelName: '',
        tokenizerPath: '',
        maxContextTokens: 16000,
        temperature: 1,
        minP: 0,
        topP: 1,
        repeatPenalty: 1,
        globalSystemPrompt: '',
        template: '',
        provider: '',
      ),
      providers: [],
    );
  }

  Future<AllSettings> getFakeProviderSettings(String provider) async {
    // TODO
    return getAllSettings();
  }

  Future<SettingsBase> updateSettings(SettingsBase settings) async {
    // TODO
    return (await getAllSettings()).settings;
  }
}
