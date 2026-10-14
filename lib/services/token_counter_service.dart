import 'dart:io';
import 'package:flutter/services.dart';
import 'package:dart_sentencepiece_tokenizer/dart_sentencepiece_tokenizer.dart';

class TokenCounterService {
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
      return tokenizer.encode(text).length;
    } catch (e) {
      return (text.length / 2).ceil();
    }
  }
}
