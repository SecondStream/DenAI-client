import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/base_repository.dart';
import 'package:den_ai/repositories/provider/remote_provider.dart';

class SettingsRepository extends BaseRepository {
  SettingsRepository(RemoteProvider remote) : super(remote, '/settings');

  Future<AllSettings> getAllSettings() async {
    final response = await remote.get("$endpoint/all");
    return AllSettings.fromJson(response);
  }

  Future<AllSettings> getFakeProviderSettings(String provider) async {
    final response = await remote.get("$endpoint/fake-provider/$provider");
    return AllSettings.fromJson(response);
  }

  Future<SettingsBase> updateSettings(SettingsBase settings) async {
    final response = await remote.put(endpoint, data: settings.toJson());
    return SettingsBase.fromJson(response);
  }
}
