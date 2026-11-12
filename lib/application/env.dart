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
  static late final bool isFull; // Temporary flag, pending implementation of loading models over the network

  static void init({required String docPath, required String supportPath, bool prod = false, bool desktop = true, bool full = true}) {
    docDir = p.join(docPath, appName);
    supportDir = supportPath;
    isProduction = prod;
    isDesktop = desktop;
    isFull = full;

    tokenizersDir = p.join(docDir, tokenizersDirName);

    Directory(tokenizersDir).createSync(recursive: true);
  }
}
