import 'dart:io';

import 'package:file_selector/file_selector.dart';

abstract class FileTool {
  static Future<File?> pickImage() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'jpeg', 'png', 'webp'],
      uniformTypeIdentifiers: <String>['public.jpeg', 'public.png'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    return file != null ? File(file.path) : null;
  }
}
