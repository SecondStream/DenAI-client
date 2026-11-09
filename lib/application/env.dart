import 'dart:io';

import 'package:path/path.dart' as p;

abstract class AppEnv {
  static const String appName = 'DenAI';
  static const String tokenizersDirName = 'tokenizers';
  static late final String docDir;
  static late final String supportDir;
  static late final String tokenizersDir;
  static late final bool isProduction;
  static late final bool isDesktop;

  static void init({required String docPath, required String supportPath, bool prod = false, bool desktop = true}) {
    docDir = p.join(docPath, appName);
    supportDir = supportPath;
    isProduction = prod;
    isDesktop = desktop;

    tokenizersDir = p.join(docDir, tokenizersDirName);

    Directory(tokenizersDir).createSync(recursive: true);
  }
}
