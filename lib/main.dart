import 'package:chat_bot_client/application/app.dart';
import 'package:chat_bot_client/application/config.dart';
import 'package:chat_bot_client/application/di_initializer.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DiInitializer.init();
  await _ensureBackendRunning();
  runApp(AppConfig(baseUrl: 'http://127.0.0.1:8000', child: ChatApp()));
}

Future<void> _ensureBackendRunning() async {
  try {
    final socket = await Socket.connect(
      '127.0.0.1',
      8000,
      timeout: const Duration(milliseconds: 500),
    );
    await socket.close();
  } catch (_) {
    const String backendPath = 'G:\\Projects\\py_test';
    await Process.start(
      'uvicorn',
      ['app.main:app', '--host', '127.0.0.1', '--port', '8000'],
      workingDirectory: backendPath,
      runInShell: true,
    );
    await Future.delayed(const Duration(milliseconds: 1500));
  }
}
