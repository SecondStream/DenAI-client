import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:den_ai/application/env.dart';
import 'package:den_ai/tools/file_tool.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';

class STTTool {
  SendPort? _workerPort;
  Completer<String?>? _currentTask;
  bool _initAttempted = false;

  Future<void> init() async {
    if (_initAttempted) return;
    _initAttempted = true;

    final path = FileTool.sttModelsPath;
    if (path == null) return;

    final receivePort = ReceivePort();
    final ready = Completer<SendPort?>();

    await Isolate.spawn(_workerEntry, (
    receivePort.sendPort,
    path.encoder,
    path.decoder,
    path.joiner,
    path.tokens,
    AppEnv.isDesktop ? 4 : 2,
    !AppEnv.isProduction,
    ));

    receivePort.listen((msg) {
      if (!ready.isCompleted) {
        ready.complete(msg as SendPort?);
        if (msg == null) receivePort.close();
        return;
      }

      _currentTask?.complete(msg as String?);
      _currentTask = null;
    });

    _workerPort = await ready.future;
  }

  Future<String?> recognize(Float32List samples) async {
    if (!_initAttempted) await init();
    if (_workerPort == null || _currentTask != null) return null;

    _currentTask = Completer<String?>();
    _workerPort!.send(TransferableTypedData.fromList([samples]));
    return _currentTask!.future;
  }

  static void _workerEntry(
      (SendPort, String, String, String, String, int, bool) args,
      ) {
    final (mainPort, encoder, decoder, joiner, tokens, threads, debug) = args;
    final workerPort = ReceivePort();

    final OfflineRecognizer recognizer;
    try {
      initBindings();
      recognizer = OfflineRecognizer(
        OfflineRecognizerConfig(
          feat: FeatureConfig(sampleRate: 16000, featureDim: 80),
          model: OfflineModelConfig(
            transducer: OfflineTransducerModelConfig(
              encoder: encoder,
              decoder: decoder,
              joiner: joiner,
            ),
            tokens: tokens,
            numThreads: threads,
            debug: debug,
            modelType: 'nemo_transducer',
          ),
          decodingMethod: 'greedy_search',
        ),
      );
    } catch (_) {
      workerPort.close();
      mainPort.send(null);
      return;
    }

    mainPort.send(workerPort.sendPort);

    workerPort.listen((msg) {
      OfflineStream? stream;
      try {
        final samples = (msg as TransferableTypedData).materialize().asFloat32List();
        stream = recognizer.createStream();
        stream.acceptWaveform(samples: samples, sampleRate: 16000);
        recognizer.decode(stream);
        mainPort.send(recognizer.getResult(stream).text);
      } catch (_) {
        mainPort.send(null);
      } finally {
        stream?.free();
      }
    });
  }
}