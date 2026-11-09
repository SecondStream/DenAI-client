import 'dart:io';
import 'package:flutter/services.dart';
import 'package:dart_sentencepiece_tokenizer/dart_sentencepiece_tokenizer.dart';

class TokenCounterService {
  static const maxLength = 2000;
  static final Map<String, SentencePieceTokenizer> _tokenizerCache = {};

  Future<int> countTokens({required String text, required String tokenizerPath}) async {
    if (text.isEmpty) return 0;
    try {
      if (!_tokenizerCache.containsKey(tokenizerPath)) {
        final String jsonString = tokenizerPath.startsWith('assets/')
            ? await rootBundle.loadString(tokenizerPath)
            : await File(tokenizerPath).readAsString();
        _tokenizerCache[tokenizerPath] = TokenizerJsonLoader.fromJsonString(jsonString);
      }
      final tokenizer = _tokenizerCache[tokenizerPath]!;
      var len = 0;
      for (int i = 0; i < text.length; i += maxLength) {
        int end = (i + maxLength < text.length) ? i + maxLength : text.length;
        len += tokenizer.encode(text.substring(i, end)).length;
      }
      return len;
    } catch (e) {
      return (text.length / 2).ceil();
    }
  }
}
