import 'package:den_ai/application/routes.dart';
import 'package:den_ai/clients/openai_client.dart';
import 'package:den_ai/repositories/characters_repository.dart';
import 'package:den_ai/repositories/chats_repository.dart';
import 'package:den_ai/repositories/database.dart';
import 'package:den_ai/repositories/lorebooks_repository.dart';
import 'package:den_ai/repositories/provider/remote_provider.dart';
import 'package:den_ai/repositories/provider/interceptor.dart';
import 'package:den_ai/repositories/settings_repository.dart';
import 'package:den_ai/repositories/user_cards_repository.dart';
import 'package:den_ai/services/chat_generation_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class DiInitializer {
  static void init() {
    final di = GetIt.instance;

    final dio = Dio();
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(LogInterceptor());

    final remoteProvider = RemoteProvider(dio);
    final database = AppDatabase();
    di.registerSingleton(remoteProvider);
    di.registerSingleton(AppRouteObserver());

    final client = OpenAIClient(
      url: 'https://routerai.ru/api/v1',
      key: 'sk-HC458Rw5HzWj050i2OFYGoyJwsFe8Rvx',
      defaultModel: 'google/gemma-4-31b-it',
      defaultVisionModel: 'google/gemma-4-31b-it',
      dio: dio,
    );
    final chatsRepo = ChatsRepository(database);

    di.registerSingleton(chatsRepo);
    di.registerSingleton(client);
    di.registerSingleton(CharactersRepository(database));
    di.registerSingleton(UserCardsRepository(database));
    di.registerSingleton(SettingsRepository(database));
    di.registerSingleton(LorebooksRepository(database));
    di.registerSingleton(ChatGenerationService(client: client, repository: chatsRepo));
  }
}
