import 'dart:io';
import 'dart:typed_data';
import 'package:den_ai/application/env.dart';
import 'package:path/path.dart' as p;

class LoreVectorStorage {
  static const String _subDir = 'lore_vectors';

  static Future<bool> hasVectorFiles() async {
    final Directory targetDir = Directory(p.join(AppEnv.supportDir, _subDir));
    if (!await targetDir.exists()) {
      return false;
    }

    try {
      await for (final entity in targetDir.list()) {
        if (entity is File && p.extension(entity.path) == '.bin') {
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  Future<File> _getVectorFile(int lorebookId) async {
    final Directory targetDir = Directory(p.join(AppEnv.supportDir, _subDir));

    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    return File(p.join(targetDir.path, 'vectors_$lorebookId.bin'));
  }

  Future<void> saveVectors(int lorebookId, List<List<double>> embeddings) async {
    if (embeddings.isEmpty) return;

    final int rows = embeddings.length;
    final int cols = embeddings.first.length;

    final int totalBytes = 8 + (rows * cols * 4);
    final Uint8List bytes = Uint8List(totalBytes);
    final ByteData byteData = ByteData.sublistView(bytes);

    byteData.setInt32(0, rows, Endian.little);
    byteData.setInt32(4, cols, Endian.little);

    int offset = 8;
    for (final row in embeddings) {
      for (final val in row) {
        byteData.setFloat32(offset, val, Endian.little);
        offset += 4;
      }
    }

    final File file = await _getVectorFile(lorebookId);
    await file.writeAsBytes(bytes, mode: FileMode.write, flush: true);
  }

  Future<List<List<double>>> loadVectors(int lorebookId) async {
    try {
      final File file = await _getVectorFile(lorebookId);
      if (!await file.exists()) return const [];

      final Uint8List bytes = await file.readAsBytes();
      if (bytes.length < 8) return const [];

      final ByteData byteData = ByteData.sublistView(bytes);

      final int rows = byteData.getInt32(0, Endian.little);
      final int cols = byteData.getInt32(4, Endian.little);

      if (bytes.length != 8 + (rows * cols * 4)) {
        throw Error();
      }

      final List<List<double>> result = List.generate(rows, (_) => List<double>.filled(cols, 0.0));

      int offset = 8;
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          result[i][j] = byteData.getFloat32(offset, Endian.little);
          offset += 4;
        }
      }

      return result;
    } catch (e) {
      return const [];
    }
  }

  Future<void> deleteVectors(int lorebookId) async {
    final File file = await _getVectorFile(lorebookId);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
