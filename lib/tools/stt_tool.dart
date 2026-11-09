import 'dart:typed_data';

import 'package:den_ai/application/env.dart';
import 'package:den_ai/tools/file_tool.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';

class STTTool {
  final OfflineRecognizer? _recognizer;

  STTTool() : _recognizer = _createRecognizer();

  String? recognize(Float32List samples) {
    final recognizer = _recognizer;
    if (recognizer != null) {
      final stream = recognizer.createStream();
      stream.acceptWaveform(samples: samples, sampleRate: 16000);
      recognizer.decode(stream);
      final result = recognizer.getResult(stream);
      stream.free();
      return result.text;
    }

    return null;
  }

  void dispose() {
    _recognizer?.free();
  }

  static OfflineRecognizer? _createRecognizer() {
    final path = FileTool.ttsModelsPath;
    if (path != null) {
      final transducerConfig = OfflineTransducerModelConfig(
        encoder: path.encoder,
        decoder: path.decoder,
        joiner: path.joiner,
      );

      final modelConfig = OfflineModelConfig(
        transducer: transducerConfig,
        tokens: path.tokens,
        numThreads: AppEnv.isDesktop ? 4 : 2,
        debug: !AppEnv.isProduction,
        modelType: 'nemo_transducer',
      );

      final featConfig = FeatureConfig(sampleRate: 16000, featureDim: 80);

      final config = OfflineRecognizerConfig(
        feat: featConfig,
        model: modelConfig,
        decodingMethod: 'greedy_search',
      );

      return OfflineRecognizer(config);
    }

    return null;
  }
}
