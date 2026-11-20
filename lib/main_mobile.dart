import 'package:den_ai/application/app.dart';
import 'package:den_ai/application/di_initializer.dart';
import 'package:den_ai/application/env.dart';
import 'package:den_ai/application/logger.dart';
import 'package:den_ai/repositories/statistics_repository.dart';
import 'package:den_ai/widgets/status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'models/statistic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final paths = await Future.wait([
    getApplicationDocumentsDirectory(),
    getApplicationSupportDirectory(),
  ]);

  final info = await PackageInfo.fromPlatform();

  AppEnv.init(
    docPath: paths[0].path,
    supportPath: paths[1].path,
    prod: kReleaseMode,
    desktop: false,
    full: false,
    siteBaseUrl: 'https://realwaifu.ru',
    packageInfo: info,
  );
  await DiInitializer.init();

  try {
    await AppLogger.init(info.version);

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      AppLogger.error('FlutterError', error: details.exception, stackTrace: details.stack);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      AppLogger.error('Uncaught Platform Error', error: error, stackTrace: stack);
      return true;
    };

    await GetIt.instance.get<StatisticsRepository>().increment(StatEventType.appLaunchCount);
  } catch (_) {}

  runApp(AppStatus(child: ChatApp()));
}
