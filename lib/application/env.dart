import 'dart:io';

import 'package:path/path.dart' as p;

abstract class AppEnv {
  static const String appName = 'DenAI';
  static const String tokenizersDirName = 'tokenizers';
  static late final String docDir;
  static late final String supportDir;
  static late final String tokenizersDir;
  static late final bool isProduction;

  static void init({required String docPath, required String supportPath, bool prod = false}) {
    docDir = p.join(docPath, appName);
    supportDir = supportPath;
    isProduction = prod;
    tokenizersDir = p.join(docDir, tokenizersDirName);

    Directory(tokenizersDir).createSync(recursive: true);
  }
}
