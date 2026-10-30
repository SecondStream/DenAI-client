import 'package:den_ai/application/app.dart';
import 'package:den_ai/application/config.dart';
import 'package:den_ai/application/di_initializer.dart';
import 'package:den_ai/application/env.dart';
import 'package:den_ai/widgets/status.dart';
import 'package:den_ai/widgets/window_observer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final paths = await Future.wait([
    getApplicationDocumentsDirectory(),
    getApplicationSupportDirectory(),
  ]);

  AppEnv.init(docPath: paths[0].path, supportPath: paths[1].path, prod: false);

  await DiInitializer.init();

  await windowManager.ensureInitialized();
  final prefs = GetIt.instance.get<SharedPreferences>();
  final isFullScreen = prefs.getBool('window_maximize') ?? false;
  final width = prefs.getDouble('window_width') ?? 1280;
  final height = prefs.getDouble('window_height') ?? 900;
  final x = prefs.getDouble('window_x');
  final y = prefs.getDouble('window_y');

  WindowOptions windowOptions = WindowOptions(
    size: Platform.isLinux ? Size(width, height) : null,
    minimumSize: Size(900, 800),
    center: x == null || y == null,
    title: "DenAI",
  );
  if (Platform.isWindows || Platform.isLinux) {
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      if (isFullScreen) await windowManager.maximize();
    });
  }

  runApp(
    AppConfig(
      baseUrl: AppEnv.supportDir,
      siteUrl: 'https://realwaifu.ru/denai',
      child: WindowObserver(child: AppStatus(child: ChatApp())),
    ),
  );
}
