import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig extends InheritedWidget {
  final String baseUrl;
  final String siteUrl;
  final PackageInfo info;

  String get version => '${info.version}-beta';

  const AppConfig({super.key, required this.baseUrl, required this.siteUrl, required this.info, required super.child});

  static AppConfig of(BuildContext context) {
    final AppConfig? result = context.dependOnInheritedWidgetOfExactType<AppConfig>();
    assert(result != null, 'No AppConfig found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppConfig oldWidget) => false;
}
