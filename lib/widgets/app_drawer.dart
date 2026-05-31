import 'package:chat_bot_client/application/config.dart';
import 'package:chat_bot_client/application/l10n.dart';
import 'package:chat_bot_client/application/routes.dart';
import 'package:chat_bot_client/blocs/drawer/drawer_bloc.dart';
import 'package:chat_bot_client/extensions/navigation_ext.dart';
import 'package:chat_bot_client/models/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final loc = AppLocalization.of(context);

    return BlocProvider<DrawerBloc>(
      create: (context) => DrawerBloc(GetIt.instance.get())..add(DrawerShownEvent()),
      child: Drawer(
        backgroundColor: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: theme.appBarTheme.backgroundColor),
              child: Center(
                child: BlocBuilder<DrawerBloc, DrawerState>(
                  builder: (context, state) {
                    return _buildUserCard(
                      context,
                      theme,
                      state is DrawerLoadSuccessState ? state.userCard : null,
                    );
                  },
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble, color: Colors.white70),
              title: Text(loc.myChats, style: TextStyle(color: Colors.white)),
              selected: currentRoute == AppRoutes.chats || currentRoute == AppRoutes.home,
              selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                context.pop();
                context.replace(AppRoutes.chats);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.white70),
              title: Text(loc.characters, style: TextStyle(color: Colors.white)),
              selected: currentRoute == AppRoutes.characters,
              selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                context.pop(context);
                context.replace(AppRoutes.characters);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_box, color: Colors.white70),
              title: Text(loc.myCards, style: TextStyle(color: Colors.white)),
              selected: currentRoute == AppRoutes.userCards,
              selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                context.pop();
                context.replace(AppRoutes.userCards);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white70),
              title: Text(loc.settings, style: TextStyle(color: Colors.white)),
              selected: currentRoute == AppRoutes.settings,
              selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                context.pop();
                context.replace(AppRoutes.settings);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, ThemeData theme, UserCard? card) {
    final avatarUrl = card?.getAvatar(AppConfig.of(context).baseUrl);

    return BlocBuilder<DrawerBloc, DrawerState>(
      builder: (context, state) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: avatarUrl != null
              ? Image.network(avatarUrl, fit: BoxFit.cover)
              : const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
        );
      },
    );
  }
}
