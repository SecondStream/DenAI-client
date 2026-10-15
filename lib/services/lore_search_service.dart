import 'dart:math' as math;

class BM25Okapi {
  final List<List<String>> corpus;
  final double k1;
  final double b;

  late final int _corpusSize;
  late final double _avgDocLength;
  late final List<int> _docLengths;
  final Map<String, int> _nd = {};
  final List<Map<String, int>> _tf = [];

  BM25Okapi(this.corpus, {this.k1 = 1.5, this.b = 0.75}) {
    _corpusSize = corpus.length;
    _docLengths = corpus.map((doc) => doc.length).toList();
    _avgDocLength = _docLengths.isEmpty ? 0.0 : _docLengths.reduce((a, b) => a + b) / _corpusSize;

    for (final doc in corpus) {
      final Map<String, int> localTf = {};
      for (final token in doc) {
        localTf[token] = (localTf[token] ?? 0) + 1;
      }
      _tf.add(localTf);

      for (final token in localTf.keys) {
        _nd[token] = (_nd[token] ?? 0) + 1;
      }
    }
  }

  List<double> getScores(List<String> query) {
    final List<double> scores = List<double>.filled(_corpusSize, 0.0);

    for (int i = 0; i < _corpusSize; i++) {
      final int docLen = _docLengths[i];
      final Map<String, int> localTf = _tf[i];
      double score = 0.0;

      for (final token in query) {
        if (!localTf.containsKey(token)) continue;

        final int freq = localTf[token]!;
        final int n = _nd[token] ?? 0;

        final double idf = math.log((_corpusSize - n + 0.5) / (n + 0.5) + 1.0);

        final double numerator = freq * (k1 + 1.0);
        final double denominator = freq + k1 * (1.0 - b + b * (docLen / _avgDocLength));

        score += idf * (numerator / denominator);
      }
      scores[i] = score;
    }

    return scores;
  }
}

class LoreSearchService {
  // List<String> _cleanText(String text) {
  //   return text
  //       .toLowerCase()
  //       .replaceAll(RegExp(r'[^\w\sа-яА-ЯёЁ]'), ' ')
  //       .split(RegExp(r'\s+'))
  //       .where((token) => token.trim().isNotEmpty)
  //       .toList();
  // }

  double _calculateCosineSimilarity(List<double> vecA, List<double> vecB) {
    if (vecA.length != vecB.length || vecA.isEmpty) return 0.0;
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;
    for (int i = 0; i < vecA.length; i++) {
      dotProduct += vecA[i] * vecB[i];
      normA += vecA[i] * vecA[i];
      normB += vecB[i] * vecB[i];
    }
    if (normA == 0.0 || normB == 0.0) return 0.0;
    return dotProduct / (math.sqrt(normA) * math.sqrt(normB));
  }

  String findRelevantLore({
    required String userInput,
    required List<String> entriesText,
    required List<List<double>> allVectors,
    required List<double> queryVector,
    double threshold = 0.49,
    int topK = 1,
  }) {
    if (entriesText.isEmpty) return "";
    final List<double> vectorScores = List<double>.filled(entriesText.length, 0.0);
    double maxVectorScore = -1.0;

    if (queryVector.isNotEmpty && allVectors.length == entriesText.length) {
      for (int i = 0; i < entriesText.length; i++) {
        final double score = _calculateCosineSimilarity(queryVector, allVectors[i]);
        vectorScores[i] = score;
        if (score > maxVectorScore) {
          maxVectorScore = score;
        }
      }
    }

    // final double superThreshold = threshold + 0.15;
    // if (entriesText.length < 5 || maxVectorScore >= superThreshold) {
    //   return _selectionByScores(entriesText, vectorScores, threshold, topK);
    // }

    // final List<String> tokenizedQuery = _cleanText(userInput);
    // final List<List<String>> cleanedEntries = entriesText.map((t) => _cleanText(t)).toList();

    // final bm25 = BM25Okapi(cleanedEntries);
    // final List<double> rawBm25Scores = bm25.getScores(tokenizedQuery);

    // double maxBm25 = 0.0;
    // for (final score in rawBm25Scores) {
    //   if (score > maxBm25) maxBm25 = score;
    // }

    // final List<double> bm25Scores = List<double>.filled(rawBm25Scores.length, 0.0);
    // if (maxBm25 > 0) {
    //   for (int i = 0; i < rawBm25Scores.length; i++) {
    //     bm25Scores[i] = rawBm25Scores[i] / maxBm25;
    //   }
    // }

    // final List<double> hybridScores = List<double>.filled(entriesText.length, 0.0);
    // const double alpha = 0.6;
    // for (int i = 0; i < entriesText.length; i++) {
    //   hybridScores[i] = (alpha * bm25Scores[i]) + ((1.0 - alpha) * vectorScores[i]);
    // }

    return _selectionByScores(entriesText, vectorScores, threshold, topK);
  }

  String _selectionByScores(List<String> texts, List<double> scores, double threshold, int topK) {
    final List<MapEntry<int, double>> scoredIndices = [];
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] >= threshold) {
        scoredIndices.add(MapEntry(i, scores[i]));
      }
    }

    if (scoredIndices.isEmpty) return "";

    scoredIndices.sort((a, b) => b.value.compareTo(a.value));

    final int limit = math.min(topK, scoredIndices.length);
    final List<String> resultTexts = [];
    for (int i = 0; i < limit; i++) {
      resultTexts.add(texts[scoredIndices[i].key]);
    }

    return resultTexts.join("\n\n");
  }
}
