import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final String baseUrl;

  const AppConfig({super.key, required this.baseUrl, required super.child});

  static AppConfig of(BuildContext context) {
    final AppConfig? result = context.dependOnInheritedWidgetOfExactType<AppConfig>();
    assert(result != null, 'No AppConfig found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppConfig oldWidget) => false;
}
