import 'package:den_ai/application/app.dart';
import 'package:den_ai/application/config.dart';
import 'package:den_ai/application/di_initializer.dart';
import 'package:den_ai/application/env.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: Size(1280, 900),
      center: true,
      minimumSize: Size(800, 800),
      title: "DenAI",
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  final paths = await Future.wait([
    getApplicationDocumentsDirectory(),
    getApplicationSupportDirectory(),
  ]);

  AppEnv.init(docPath: paths[0].path, supportPath: paths[1].path, prod: false);

  DiInitializer.init();

  runApp(AppConfig(baseUrl: AppEnv.supportDir, child: ChatApp()));
}
