import 'dart:async';
import 'dart:io';
import 'package:den_ai/application/env.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class AppLogger {
  AppLogger._();

  static IOSink? _sink;
  static File? _currentFile;
  static bool _initialized = false;

  static const int _maxFileSize = 2 * 1024 * 1024;

  static final List<RegExp> _secretPatterns = [
    RegExp(r'(Bearer\s+)[A-Za-z0-9\-._~+/]+=*', caseSensitive: false),
    RegExp(r'(sk-[a-zA-Z0-9]{10,})'),
    RegExp(r'("?(?:api_?key|token|secret|password)"?\s*[:=]\s*"?)[^"\s,}]+', caseSensitive: false),
  ];

  static String? lastError;

  static Future<void> init(String appVersion) async {
    if (_initialized) return;
    try {
      final logDir = Directory(p.join(AppEnv.supportDir, 'logs'));
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      _currentFile = File(p.join(logDir.path, 'denai.log'));
      await _rotateIfNeeded();

      _sink = _currentFile!.openWrite(mode: FileMode.append);
      _sink!.done.catchError((_) {});
      _initialized = true;

      info(
        '=== Session started | App: $appVersion | OS: ${Platform.operatingSystem} ${Platform.operatingSystemVersion} ===',
      );
    } catch (e) {
      debugPrint('AppLogger init failed: $e');
    }
  }

  static void info(String message) => _write('INFO', message);

  static void warn(String message) => _write('WARN', message);

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    final buffer = StringBuffer(message);
    if (error != null) {
      lastError = _sanitize('$error');
      buffer.write('\n  Error: $error');
    }
    if (stackTrace != null) buffer.write('\n  StackTrace:\n$stackTrace');
    _write('ERROR', buffer.toString());
  }

  static void _write(String level, String rawMessage) {
    if (!_initialized) return;
    try {
      final timestamp = DateTime.now().toIso8601String();
      final safeMessage = _sanitize(rawMessage);
      final line = '[$timestamp] [$level] $safeMessage';

      if (kDebugMode) {
        debugPrint(line);
      }

      _sink?.writeln(line);
    } catch (_) {}
  }

  static String _sanitize(String input) {
    var result = input;
    for (final pattern in _secretPatterns) {
      result = result.replaceAllMapped(pattern, (match) {
        if (match.groupCount >= 1 && match.group(1) != null) {
          return '${match.group(1)}***';
        }
        return '***';
      });
    }
    return result;
  }

  static Future<void> _rotateIfNeeded() async {
    if (_currentFile == null || !await _currentFile!.exists()) return;

    final size = await _currentFile!.length();
    if (size >= _maxFileSize) {
      final backupFile = File(p.join(_currentFile!.parent.path, 'denai.prev.log'));
      if (await backupFile.exists()) {
        await backupFile.delete();
      }
      await _currentFile!.rename(backupFile.path);
    }
  }

  static Future<File?> getLogFileForExport() async {
    await _sink?.flush();
    if (_currentFile != null && await _currentFile!.exists()) {
      return _currentFile;
    }
    return null;
  }

  static Future<void> dispose() async {
    await _sink?.flush();
    await _sink?.close();
    _sink = null;
    _initialized = false;
  }
}
