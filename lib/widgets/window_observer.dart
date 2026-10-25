import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class WindowObserver extends StatefulWidget {
  final Widget child;
  const WindowObserver({super.key, required this.child});

  @override
  State<WindowObserver> createState() => _WindowObserverState();
}

class _WindowObserverState extends State<WindowObserver> with WindowListener {
  late SharedPreferences _prefs;
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _prefs = GetIt.instance.get();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResize() async {
    final size = await windowManager.getSize();
    await _prefs.setDouble('window_width', size.width);
    await _prefs.setDouble('window_height', size.height);
    final position = await windowManager.getPosition();
    await _prefs.setDouble('window_x', position.dx);
    await _prefs.setDouble('window_y', position.dy);
  }

  @override
  void onWindowMoved() async {
    final position = await windowManager.getPosition();
    await _prefs.setDouble('window_x', position.dx);
    await _prefs.setDouble('window_y', position.dy);
  }

  @override
  void onWindowMaximize() =>  _prefs.setBool('window_maximize', true);

  @override
  void onWindowUnmaximize() =>  _prefs.setBool('window_maximize', false);

  @override
  void onWindowEnterFullScreen() =>  _prefs.setBool('window_maximize', true);

  @override
  void onWindowLeaveFullScreen() =>  _prefs.setBool('window_maximize', false);

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}