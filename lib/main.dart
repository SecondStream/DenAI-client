import 'package:den_ai/application/app.dart';
import 'package:den_ai/application/config.dart';
import 'package:den_ai/application/di_initializer.dart';
import 'package:den_ai/application/env.dart';
import 'package:den_ai/widgets/status.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final window = WindowManager.instance.getCurrent();

  final paths = await Future.wait([
    getApplicationDocumentsDirectory(),
    getApplicationSupportDirectory(),
  ]);

  AppEnv.init(docPath: paths[0].path, supportPath: paths[1].path, prod: true);
  await DiInitializer.init();

  if (window != null) {
    final prefs = GetIt.instance.get<SharedPreferences>();

    final isFullScreen = prefs.getBool('window_maximize') ?? false;
    final width = prefs.getDouble('window_width') ?? 1280;
    final height = prefs.getDouble('window_height') ?? 900;
    final x = prefs.getDouble('window_x');
    final y = prefs.getDouble('window_y');

    window.title = 'DenAI';
    window.minimumSize = const Size(900, 800).toNative();
    if (Platform.isLinux) {
      window.setSize(Size(width, height).toNative(), false);
    }
    if (x == null || y == null) {
      window.center();
    }
    if ((Platform.isWindows || Platform.isLinux) && isFullScreen) {
      window.maximize();
    }

    window.addListener((event) {
      if (event is WindowMaximizedEvent) {
        prefs.setBool('window_maximize', true);
      } else if (event is WindowRestoredEvent) {
        prefs.setBool('window_maximize', false);
      } else if (event is WindowResizedEvent) {
        final size = event.newSize;
        if (!window.isMaximized && !window.isMinimized) {
          prefs.setDouble('window_width', size.width);
          prefs.setDouble('window_height', size.height);
          final position = window.position;
          prefs.setDouble('window_x', position.x);
          prefs.setDouble('window_y', position.y);
        }
      } else if (event is WindowMovedEvent) {
        if (!window.isMaximized && !window.isMinimized) {
          final position = event.newPosition;
          prefs.setDouble('window_x', position.x);
          prefs.setDouble('window_y', position.y);
        }
      }
    });
  }

  runApp(
    AppConfig(
      baseUrl: AppEnv.supportDir,
      siteUrl: 'https://realwaifu.ru/denai',
      info: await PackageInfo.fromPlatform(),
      child: AppStatus(child: ChatApp()),
    ),
  );
}
