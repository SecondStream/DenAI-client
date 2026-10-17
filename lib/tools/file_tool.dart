import 'dart:io';

import 'package:path/path.dart' as p;

import 'package:den_ai/application/l10n.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';

abstract class FileTool {
  static const String _avatarsDir = 'avatars';
  static const String _backgroundsDir = 'backgrounds';
  static const String _attachmentsDir = 'attachments';

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
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory targetDir = Directory(p.join(appDocDir.path, subDir));
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
    final Directory targetFolder = await _getDirectory(_avatarsDir);
    final String extension = p.extension(file.path);
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final String fileName = '${prefix}_$timestamp$extension';
    final String finalPath = p.join(targetFolder.path, fileName);
    await file.copy(finalPath);
    return p.join(_avatarsDir, fileName);
  }

  static Future<File> getFileFromRelativePath(String relativePath) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    return File(p.join(appDocDir.path, relativePath));
  }
}
