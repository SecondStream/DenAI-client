import 'dart:io';

import 'package:den_ai/application/l10n.dart';
import 'package:file_selector/file_selector.dart';

abstract class FileTool {
  static Future<File?> pickImage() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'jpeg', 'png', 'webp'],
      uniformTypeIdentifiers: <String>[
        'public.jpeg',
        'public.png',
        'public.webp',
      ],
    );
    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
    );
    return file != null ? File(file.path) : null;
  }

  static Future<File?> pickCard() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'card v2',
      extensions: <String>['png', 'json'],
      uniformTypeIdentifiers: <String>['public.png', 'public.json'],
    );
    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
    );
    return file != null ? File(file.path) : null;
  }

  static Future<String?> getExportPath(AppLocalization loc, String charName) async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'PNG images',
      extensions: <String>['png'],
    );

    final output = await getSaveLocation(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
      suggestedName: '$charName.png',
      confirmButtonText: loc.export,
      canCreateDirectories: true,
    );

    return output?.path;
  }
}
