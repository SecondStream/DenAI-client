import 'package:chat_bot_client/repositories/characters_repository.dart';
import 'package:chat_bot_client/repositories/chats_repository.dart';
import 'package:chat_bot_client/repositories/provider/remote_provider.dart';
import 'package:chat_bot_client/repositories/provider/interceptor.dart';
import 'package:chat_bot_client/repositories/user_cards_repository.dart';
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

    di.registerSingleton(ChatsRepository(remoteProvider));
    di.registerSingleton(CharactersRepository(remoteProvider));
    di.registerSingleton(UserCardsRepository(remoteProvider));
  }
}
