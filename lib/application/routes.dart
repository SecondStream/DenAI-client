import 'package:den_ai/models/models.dart';
import 'package:den_ai/screens/character_form_screen.dart';
import 'package:den_ai/screens/characters_screen.dart';
import 'package:den_ai/screens/chat_lists_screen.dart';
import 'package:den_ai/screens/chat_screen.dart';
import 'package:den_ai/screens/lorebook_entries_screen.dart';
import 'package:den_ai/screens/lorebook_form_screen.dart';
import 'package:den_ai/screens/lorebooks_screen.dart';
import 'package:den_ai/screens/settings_screen.dart';
import 'package:den_ai/screens/user_card_form_screen.dart';
import 'package:den_ai/screens/user_cards_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/';
  static const String chat = '/chat';
  static const String characters = '/characters';
  static const String userCards = '/user_cards';
  static const String characterEdit = '/characters/edit';
  static const String userCardEdit = '/user_cards/edit';
  static const String settings = '/settings';
  static const String lorebooks = '/lorebooks';
  static const String lorebookEdit = '/lorebooks/edit';
  static const String loreEntries = 'lorebooks/entries';

  static Route<dynamic> createRoute(String? route, {required RouteSettings settings}) {
    return _createRoute(route ?? '', settings);
  }

  static Widget _buildByRoute(BuildContext context, String route, Object? args) {
    switch (route) {
      case home:
        return const ChatsListScreen();
      case characters:
        return const CharactersScreen();
      case userCards:
        return const UserCardsScreen();
      case characterEdit:
        return CharacterFormScreen(characterId: args as int?);
      case chat:
        return ChatScreen(args: args as ChatScreenArgs);
      case userCardEdit:
        return UserCardFormScreen(card: args as UserCard?);
      case settings:
        return SettingsScreen();
      case lorebooks:
        return LorebooksScreen();
      case lorebookEdit:
        return LorebookFormScreen(lorebook: args as Lorebook?);
      case loreEntries:
        return LorebookEntriesScreen(bookId: args as int);
    }
    throw Exception('Unknown route: $route');
  }

  static Route<dynamic> _createRoute<T>(String route, RouteSettings settings) {
    return MaterialPageRoute<T>(
      builder: (ctx) => _buildByRoute(ctx, route, settings.arguments),
      settings: settings,
    );
  }
}

class AppRouteObserver extends NavigatorObserver {
  String? currentRouteName;
  Object? currentArguments;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _extractRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) _extractRoute(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _extractRoute(newRoute);
  }

  void _extractRoute(Route<dynamic> route) {
    currentRouteName = route.settings.name;
    currentArguments = route.settings.arguments;
  }
}
