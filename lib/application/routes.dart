import 'package:chat_bot_client/models/models.dart';
import 'package:chat_bot_client/screens/character_form_screen.dart';
import 'package:chat_bot_client/screens/characters_screen.dart';
import 'package:chat_bot_client/screens/chat_lists_screen.dart';
import 'package:chat_bot_client/screens/chat_screen.dart';
import 'package:chat_bot_client/screens/user_card_form_screen.dart';
import 'package:chat_bot_client/screens/user_cards_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/';
  static const String chats = '/chats';
  static const String chat = '/chat';
  static const String characters = '/characters';
  static const String userCards = '/user_cards';
  static const String characterEdit = '/characters/edit';
  static const String userCardEdit = '/user_cards/edit';

  static Route<dynamic> createRoute(String? route, {required RouteSettings settings}) {
    return _createRoute(route ?? '', settings);
  }

  static Widget _buildByRoute(BuildContext context, String route, Object? args) {
    switch (route) {
      case chats || home:
        return const ChatsListScreen();
      case characters:
        return const CharactersScreen();
      case userCards:
        return const UserCardsScreen();
      case characterEdit:
        return CharacterFormScreen(character: args as Char?);
      case chat:
        return ChatScreen(args: args as ChatScreenArgs);
      case userCardEdit:
        return UserCardFormScreen(card: args as UserCard?);
    }
    throw Exception('Unknown route: $route');
  }

  static Route<dynamic> _createRoute<T>(String route, RouteSettings settings) {
    //settings = RouteSettings(name: route, arguments: settings.arguments);
    return MaterialPageRoute<T>(
      builder: (ctx) => _buildByRoute(ctx, route, settings.arguments),
      settings: settings,
    );
  }
}
