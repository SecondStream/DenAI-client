import 'package:chat_bot_client/models/models.dart';
import 'package:chat_bot_client/repositories/base_repository.dart';
import 'package:chat_bot_client/repositories/provider/remote_provider.dart';

class SettingsRepository extends BaseRepository {
  SettingsRepository(RemoteProvider remote) : super(remote, '/settings');

  Future<AllSettings> getAllSettings() async {
    final response = await remote.get("$endpoint/all");
    return AllSettings.fromJson(response);
  }

  Future<SettingsBase> updateSettings(SettingsBase settings) async {
    final response = await remote.put(endpoint, data: settings.toJson());
    return SettingsBase.fromJson(response);
  }
}
