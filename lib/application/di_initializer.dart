import 'package:den_ai/application/routes.dart';
import 'package:den_ai/repositories/characters_repository.dart';
import 'package:den_ai/repositories/chats_repository.dart';
import 'package:den_ai/repositories/lorebooks_repository.dart';
import 'package:den_ai/repositories/provider/remote_provider.dart';
import 'package:den_ai/repositories/provider/interceptor.dart';
import 'package:den_ai/repositories/settings_repository.dart';
import 'package:den_ai/repositories/user_cards_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class DiInitializer {
  static void init() {
    final di = GetIt.instance;

    final dio = Dio();
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(LogInterceptor());

    final remoteProvider = RemoteProvider(dio);
    di.registerSingleton(remoteProvider);
    di.registerSingleton(AppRouteObserver());

    di.registerSingleton(ChatsRepository(remoteProvider));
    di.registerSingleton(CharactersRepository(remoteProvider));
    di.registerSingleton(UserCardsRepository(remoteProvider));
    di.registerSingleton(SettingsRepository(remoteProvider));
    di.registerSingleton(LorebooksRepository(remoteProvider));
  }
}
