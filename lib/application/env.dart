import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;

import 'l10n.dart';

abstract class AppEnv {
  static const String appName = 'DenAI';
  static const String tokenizersDirName = 'tokenizers';
  static late final String docDir;
  static late final String supportDir;
  static late final String tokenizersDir;
  static late final bool isProduction;
  static late final bool isDesktop;
  static late final String siteUrl;
  static late final PackageInfo info;
  static String get version => '${info.version}-beta';
  static String get baseUrl => supportDir;
  static late final bool
  isFull; // Temporary flag, pending implementation of loading models over the network

  static void init({
    required String docPath,
    required String supportPath,
    required String siteBaseUrl,
    required PackageInfo packageInfo,
    bool prod = false,
    bool desktop = true,
    bool full = true,
  }) {
    docDir = p.join(docPath, appName);
    supportDir = supportPath;
    isProduction = prod;
    isDesktop = desktop;
    isFull = full;
    siteUrl = siteBaseUrl;
    info = packageInfo;

    tokenizersDir = p.join(docDir, tokenizersDirName);

    Directory(tokenizersDir).createSync(recursive: true);
  }

  static String getSiteUrl(AppLocalization loc) {
    return '$siteUrl${loc.locale.languageCode != 'ru' ? '/en' : ''}';
  }
}
