import 'package:den_ai/application/routes.dart';
import 'package:den_ai/clients/openai_client.dart';
import 'package:den_ai/managers/lore_vector_storage.dart';
import 'package:den_ai/repositories/characters_repository.dart';
import 'package:den_ai/repositories/chats_repository.dart';
import 'package:den_ai/repositories/database.dart';
import 'package:den_ai/repositories/lorebooks_repository.dart';
import 'package:den_ai/repositories/provider/remote_provider.dart';
import 'package:den_ai/repositories/provider/interceptor.dart';
import 'package:den_ai/repositories/settings_repository.dart';
import 'package:den_ai/repositories/user_cards_repository.dart';
import 'package:den_ai/services/chat_generation_service.dart';
import 'package:den_ai/services/lore_search_service.dart';
import 'package:den_ai/services/token_counter_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiInitializer {
  static Future<void> init() async {
    final di = GetIt.instance;

    final prefs = await SharedPreferences.getInstance();
    final secureStorage = FlutterSecureStorage();
    di.registerSingleton(prefs);
    di.registerSingleton(secureStorage);

    final dio = Dio();
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(LogInterceptor());

    final remoteProvider = RemoteProvider(dio);
    final database = AppDatabase();
    di.registerSingleton(remoteProvider);
    di.registerSingleton(AppRouteObserver());

    final client = OpenAIClient(
      defaultModel: 'google/gemma-4-31b-it',
      defaultVisionModel: 'google/gemma-4-31b-it',
      defaultEmbeddingModel: 'baai/bge-m3',
      dio: dio,
    );
    final chatsRepo = ChatsRepository(database);
    final tokenCounter = TokenCounterService();

    di.registerSingleton(LoreVectorStorage());
    di.registerSingleton(LoreSearchService());
    di.registerSingleton(tokenCounter);
    di.registerSingleton(chatsRepo);
    di.registerSingleton(client);
    di.registerSingleton(CharactersRepository(database));
    di.registerSingleton(UserCardsRepository(database));
    di.registerSingleton(SettingsRepository(database, secureStorage));
    di.registerSingleton(LorebooksRepository(database));
    di.registerSingleton(ChatGenerationService(client, chatsRepo, tokenCounter));
  }
}
