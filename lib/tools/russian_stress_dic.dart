import 'dart:typed_data';
import 'package:den_ai/common/tts_assets.dart';
import 'package:flutter/services.dart';

class RussianStressDic {
  static const int _blockSize = 32;

  late final Uint8List _bytes;
  late final ByteData _view;
  late final int _totalCount;
  late final int _numBlocks;
  late final int _dataStartOffset;


  Future<void> init() async {
    final byteData = await rootBundle.load(TTSAssets.dict);
    _bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    _view = ByteData.sublistView(_bytes);
    _totalCount = _view.getUint32(0, Endian.little);
    _numBlocks = _view.getUint32(4, Endian.little);
    _dataStartOffset = 8 + _numBlocks * 4;
  }

  String addStress(String text) {
    return text.replaceAllMapped(RegExp(r'[а-яА-ЯёЁ]+'), (match) {
      final original = match.group(0)!;
      if (original.length < 3 || original.length > 22) return original;

      final targetCp1251 = _toCp1251Lower(original);
      if (targetCp1251 == null) return original;

      final code = _findCode(targetCp1251);
      if (code == null) return original;

      final isYo = (code & 0x80) != 0;
      final idx = code & 0x7F;

      if (isYo) {
        if (idx >= original.length) return original;
        final isUpper = original[idx] == original[idx].toUpperCase();
        return '${original.substring(0, idx)}${isUpper ? 'Ё' : 'ё'}${original.substring(idx + 1)}';
      } else {
        if (idx <= 0 || idx > original.length) return original;
        return '${original.substring(0, idx)}\u0301${original.substring(idx)}';
      }
    });
  }

  Uint8List? _toCp1251Lower(String word) {
    final lower = word.toLowerCase();
    final out = Uint8List(lower.length);
    for (int i = 0; i < lower.length; i++) {
      final cu = lower.codeUnitAt(i);
      if (cu >= 0x0430 && cu <= 0x044F) {
        out[i] = cu - 0x0430 + 0xE0;
      } else {
        return null;
      }
    }
    return out;
  }

  int? _findCode(Uint8List target) {
    int left = 0;
    int right = _numBlocks - 1;
    int candidateBlock = 0;

    while (left <= right) {
      final mid = (left + right) >>> 1;
      final blockOffset = _dataStartOffset + _view.getUint32(8 + mid * 4, Endian.little);
      final suffixLen = _bytes[blockOffset + 2];
      final cmp = _compareBytes(target, _bytes, blockOffset + 3, suffixLen);

      if (cmp == 0) return _bytes[blockOffset];
      if (cmp < 0) {
        right = mid - 1;
      } else {
        candidateBlock = mid;
        left = mid + 1;
      }
    }

    int pos = _dataStartOffset + _view.getUint32(8 + candidateBlock * 4, Endian.little);
    final itemsInBlock = (_candidateEnd(candidateBlock) - candidateBlock * _blockSize);
    final currentWord = Uint8List(32);
    int currentLen = 0;

    for (int i = 0; i < itemsInBlock; i++) {
      final code = _bytes[pos];
      final common = _bytes[pos + 1];
      final suffixLen = _bytes[pos + 2];
      pos += 3;

      for (int j = 0; j < suffixLen; j++) {
        currentWord[common + j] = _bytes[pos + j];
      }
      currentLen = common + suffixLen;
      pos += suffixLen;

      final cmp = _compareBytes(target, currentWord, 0, currentLen);
      if (cmp == 0) return code;
      if (cmp < 0) return null;
    }
    return null;
  }

  int _candidateEnd(int blockIdx) {
    final end = (blockIdx + 1) * _blockSize;
    return end < _totalCount ? end : _totalCount;
  }

  int _compareBytes(Uint8List target, Uint8List buf, int start, int len) {
    final minLen = target.length < len ? target.length : len;
    for (int i = 0; i < minLen; i++) {
      final diff = target[i] - buf[start + i];
      if (diff != 0) return diff;
    }
    return target.length - len;
  }
}
