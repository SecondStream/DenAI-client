import 'dart:io';

import 'package:den_ai/application/env.dart';
import 'package:den_ai/common/stt_assets.dart';
import 'package:den_ai/common/tts_assets.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import 'package:den_ai/application/l10n.dart';
import 'package:file_selector/file_selector.dart';

abstract class FileTool {
  static STTModelsPath? sttModelsPath;
  static TTSModelsPath? ttsModelsPath;
  static const String _avatarsDir = 'avatars';
  static const String _backgroundsDir = 'backgrounds';
  static const String _attachmentsDir = 'attachments';
  static const String _sttDir = 'stt';
  static const String _ttsDir = 'tts';

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

  static Future<XFile?> pickTokenizer() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'json files',
      extensions: <String>['json'],
      uniformTypeIdentifiers: <String>['tokenizer.json'],
    );
    return openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
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

  static Future<String?> getSaveLogPath(AppLocalization loc) async {
    final XTypeGroup typeGroup = XTypeGroup(label: 'Log files', extensions: <String>['log']);

    final output = await getSaveLocation(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
      suggestedName: 'denai.log',
      confirmButtonText: loc.save,
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

  static Future<String> saveAvatarBytes(Uint8List bytes, String extension) {
    return saveImageBytes(bytes, _avatarsDir, prefix: 'avatar', extension: extension);
  }

  static Future<String> saveBackground(File file) {
    return saveImage(file, _backgroundsDir, prefix: 'bg');
  }

  static Future<String> saveBackgroundBytes(Uint8List bytes, String extension) {
    return saveImageBytes(bytes, _backgroundsDir, prefix: 'bg', extension: extension);
  }

  static Future<bool> saveTokenizer(XFile file, {bool replace = false}) async {
    final dir = AppEnv.tokenizersDir;
    final path = p.join(dir, file.name);
    if (!replace) {
      if(File(path).existsSync()) return false;
    }
    final Uint8List bytes = await file.readAsBytes();
    await File(path).writeAsBytes(bytes);
    return true;
  }

  static Future<String> saveImage(File file, String directoryName, {required String prefix}) async {
    return saveImageBytes(
      await file.readAsBytes(),
      directoryName,
      prefix: prefix,
      extension: p.extension(file.path),
    );
  }

  static Future<String> saveImageBytes(
    Uint8List bytes,
    String directoryName, {
    required String prefix,
    String extension = '.webp',
  }) async {
    final Directory targetFolder = await _getDirectory(directoryName);
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final String fileName = '${prefix}_$timestamp$extension';
    final String finalPath = p.join(targetFolder.path, fileName);
    await File(finalPath).writeAsBytes(bytes);
    return p.join(directoryName, fileName);
  }

  static Future<void> copyModelFromAssets() async {
    final Directory modelSTTDir = await _getDirectory(_sttDir);
    final Directory modelTTSDir = await _getDirectory(_ttsDir);

    if (!await modelSTTDir.exists()) {
      await modelSTTDir.create(recursive: true);
    }

    if (!await modelTTSDir.exists()) {
      await modelTTSDir.create(recursive: true);
    }

    final pathSTT = modelSTTDir.path;
    final pathTTS = modelTTSDir.path;

    final sttFiles = [
      STTAssets.encoder,
      STTAssets.decoder,
      STTAssets.joiner,
      STTAssets.tokens,
      STTAssets.vad,
    ];

    for (final fileName in sttFiles) {
      final targetFile = File(p.join(pathSTT, fileName));
      if (!await targetFile.exists()) {
        final byteData = await rootBundle.load(STTAssets.folder + fileName);
        final buffer = byteData.buffer;
        await targetFile.writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
      }
    }

    final ttsFiles = [
      TTSAssets.predictor,
      TTSAssets.textEncoder,
      TTSAssets.vectorEstimator,
      TTSAssets.vocoder,
      TTSAssets.unicodeIndexer,
      TTSAssets.voice,
      TTSAssets.tts,
    ];

    for (final fileName in ttsFiles) {
      final targetFile = File(p.join(pathTTS, fileName));
      if (!await targetFile.exists()) {
        final byteData = await rootBundle.load(TTSAssets.folder + fileName);
        final buffer = byteData.buffer;
        await targetFile.writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
      }
    }

    sttModelsPath = STTModelsPath(
      encoder: p.join(pathSTT, STTAssets.encoder),
      decoder: p.join(pathSTT, STTAssets.decoder),
      joiner: p.join(pathSTT, STTAssets.joiner),
      tokens: p.join(pathSTT, STTAssets.tokens),
      vad: p.join(pathSTT, STTAssets.vad),
    );

    ttsModelsPath = TTSModelsPath(
      predictor: p.join(pathTTS, TTSAssets.predictor),
      textEncoder: p.join(pathTTS, TTSAssets.textEncoder),
      vectorEstimator: p.join(pathTTS, TTSAssets.vectorEstimator),
      vocoder: p.join(pathTTS, TTSAssets.vocoder),
      unicodeIndexer: p.join(pathTTS, TTSAssets.unicodeIndexer),
      voice: p.join(pathTTS, TTSAssets.voice),
      tts: p.join(pathTTS, TTSAssets.tts),
    );
  }
}

class TTSModelsPath {
  final String predictor;
  final String textEncoder;
  final String vectorEstimator;
  final String vocoder;
  final String unicodeIndexer;
  final String voice;
  final String tts;

  TTSModelsPath({
    required this.predictor,
    required this.textEncoder,
    required this.vectorEstimator,
    required this.vocoder,
    required this.unicodeIndexer,
    required this.voice,
    required this.tts,
  });
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
