import 'dart:io';

import 'package:den_ai/application/env.dart';
import 'package:den_ai/common/stt_assets.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import 'package:den_ai/application/l10n.dart';
import 'package:file_selector/file_selector.dart';

abstract class FileTool {
  static STTModelsPath? ttsModelsPath;
  static const String _avatarsDir = 'avatars';
  static const String _backgroundsDir = 'backgrounds';
  static const String _attachmentsDir = 'attachments';
  static const String _ttsDir = 'stt';

  static Future<File?> pickImage() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'jpeg', 'png', 'webp'],
      uniformTypeIdentifiers: <String>['public.jpeg', 'public.png', 'public.webp'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    return file != null ? File(file.path) : null;
  }

  static Future<File?> pickCard() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'card v2',
      extensions: <String>['png', 'json'],
      uniformTypeIdentifiers: <String>['public.png', 'public.json'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    return file != null ? File(file.path) : null;
  }

  static Future<String?> getExportPath(AppLocalization loc, String charName, String ext) async {
    final XTypeGroup typeGroup = XTypeGroup(label: loc.exportLabel, extensions: <String>[ext]);

    final output = await getSaveLocation(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
      suggestedName: '$charName.$ext',
      confirmButtonText: loc.export,
      canCreateDirectories: true,
    );

    return output?.path;
  }

  static Future<Directory> _getDirectory(String subDir) async {
    final Directory targetDir = Directory(p.join(AppEnv.supportDir, subDir));
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }
    return targetDir;
  }

  static Future<String> saveAttachment(File file) {
    return saveImage(file, _attachmentsDir, prefix: 'image');
  }

  static Future<String> saveAvatar(File file) {
    return saveImage(file, _avatarsDir, prefix: 'avatar');
  }

  static Future<String> saveBackground(File file) {
    return saveImage(file, _backgroundsDir, prefix: 'avatar');
  }

  static Future<String> saveImage(File file, String directoryName, {required String prefix}) async {
    final Directory targetFolder = await _getDirectory(directoryName);
    final String extension = p.extension(file.path);
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final String fileName = '${prefix}_$timestamp$extension';
    final String finalPath = p.join(targetFolder.path, fileName);
    await file.copy(finalPath);
    return p.join(directoryName, fileName);
  }

  static Future<void> copyModelFromAssets() async {
    final Directory modelDir = await _getDirectory(_ttsDir);

    if (!await modelDir.exists()) {
      await modelDir.create(recursive: true);
    }

    final path = modelDir.path;

    final files = [
      STTAssets.encoder,
      STTAssets.decoder,
      STTAssets.joiner,
      STTAssets.tokens,
      STTAssets.vad,
    ];

    for (final fileName in files) {
      final targetFile = File(p.join(path, fileName));
      if (!await targetFile.exists()) {
        final byteData = await rootBundle.load(STTAssets.folder + fileName);
        final buffer = byteData.buffer;
        await targetFile.writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
      }
    }

    ttsModelsPath = STTModelsPath(
      encoder: p.join(path, STTAssets.encoder),
      decoder: p.join(path, STTAssets.decoder),
      joiner: p.join(path, STTAssets.joiner),
      tokens: p.join(path, STTAssets.tokens),
      vad: p.join(path, STTAssets.vad),
    );
  }
}

class STTModelsPath {
  final String encoder;
  final String decoder;
  final String joiner;
  final String tokens;
  final String vad;

  STTModelsPath({
    required this.encoder,
    required this.decoder,
    required this.joiner,
    required this.tokens,
    required this.vad,
  });
}
