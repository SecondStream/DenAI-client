import 'package:flutter/material.dart';

extension NavigationExt on BuildContext {
  Future<T?> push<T>(String routeName, {Object? arguments}) async {
    final result = await Navigator.of(this).pushNamed(routeName, arguments: arguments);
    return result as T?;
  }

  Future<T?> replace<T>(String routeName, {Object? arguments}) async {
    final result = await Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
    return result as T?;
  }

  void pop<T extends Object?>([Object? result]) async {
    Navigator.of(this).pop(result);
  }
}
