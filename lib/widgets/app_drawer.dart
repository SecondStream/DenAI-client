import 'dart:io';

import 'package:den_ai/application/env.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/application/logger.dart';
import 'package:den_ai/application/routes.dart';
import 'package:den_ai/blocs/drawer/drawer_bloc.dart';
import 'package:den_ai/common/images.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/models/user_card.dart';
import 'package:den_ai/tools/file_tool.dart';
import 'package:den_ai/widgets/cropped_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';

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
        width: 280,
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
              selected: currentRoute == AppRoutes.home,
              selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                context.pop();
                context.replace(AppRoutes.home);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.white70),
              title: Text(loc.characters, style: TextStyle(color: Colors.white)),
              selected: currentRoute == AppRoutes.characters,
              selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                context.pop();
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
              leading: const Icon(Icons.menu_book, color: Colors.white70),
              title: Text(loc.lorebooks, style: TextStyle(color: Colors.white)),
              selected: currentRoute == AppRoutes.lorebooks,
              selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                context.pop();
                context.replace(AppRoutes.lorebooks);
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
            Spacer(),
            _buildLogo(context, theme),
            GestureDetector(
              onTap: () async {
                final file = await AppLogger.getLogFileForExport();
                if (file != null) {
                  if (Platform.isAndroid) {
                    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
                    return;
                  }

                  final path = await FileTool.getSaveLogPath(loc);
                  if (path != null) file.copy(path);
                }
              },
              child: Text(
                AppEnv.version,
                style: TextStyle(color: theme.hintColor, fontSize: 11),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context, ThemeData theme) {
    return Image.asset(AppImages.logo, width: 80);
  }

  Widget _buildUserCard(BuildContext context, ThemeData theme, UserCard? card) {
    final avatarUrl = card?.getAvatar(AppEnv.baseUrl);

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
              ? CroppedAvatar(imageUrl: avatarUrl, cropData: card!.getCropData(), size: 120)
              : Icon(Icons.add_a_photo, size: 40, color: theme.hintColor),
        );
      },
    );
  }
}
