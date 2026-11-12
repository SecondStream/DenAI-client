import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:den_ai/application/env.dart';
import 'package:den_ai/tools/file_tool.dart';
import 'package:den_ai/tools/russian_stress_dic.dart';
import 'package:get_it/get_it.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';

class TTSTool {
  SendPort? _workerSendPort;
  late final Future<void> _readyFuture;
  final Map<int, Completer<Uint8List?>> _pending = {};
  int _nextId = 0;

  TTSTool() {
    _readyFuture = init();
  }

  Future<void> init() async {
    final receivePort = ReceivePort();
    final errorPort = ReceivePort();
    final exitPort = ReceivePort();
    final portCompleter = Completer<SendPort>();

    errorPort.listen((err) {
      if (!portCompleter.isCompleted) portCompleter.completeError(err);
      _failAllPending(err);
    });

    exitPort.listen((_) {
      if (!portCompleter.isCompleted) {
        portCompleter.completeError(StateError('TTS Isolate completed'));
      }
      _failAllPending(StateError('TTS Isolate completed'));
    });

    receivePort.listen((message) {
      if (message is SendPort) {
        portCompleter.complete(message);
      } else if (message is List) {
        final int id = message[0];
        final Uint8List? wavBytes = message[1];
        _pending.remove(id)?.complete(wavBytes);
      }
    });

    await Isolate.spawn(
      _workerEntry,
      [receivePort.sendPort, FileTool.ttsModelsPath, AppEnv.docDir, GetIt.instance.get<RussianStressDic>()],
      onError: errorPort.sendPort,
      onExit: exitPort.sendPort,
    );

    _workerSendPort = await portCompleter.future;
  }

  void _failAllPending(Object error) {
    for (final completer in _pending.values) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    }
    _pending.clear();
  }

  Future<Uint8List?> generate({
    required String text,
    required String voice,
    int numSteps = 8,
  }) async {
    await _readyFuture;

    final port = _workerSendPort;
    if (port == null) return null;

    final id = _nextId++;
    final completer = Completer<Uint8List?>();
    _pending[id] = completer;

    final readyVoice = voice.split(':');

    port.send([id, text, int.parse(readyVoice[0]), readyVoice[1], numSteps]);
    return completer.future;
  }

  static void _workerEntry(List<dynamic> initArgs) {
    final SendPort mainSendPort = initArgs[0];
    final TTSModelsPath path = initArgs[1];
    final RussianStressDic stressDic = initArgs[3];

    initBindings();
    final tts = _createTts(path);

    final workerReceivePort = ReceivePort();
    mainSendPort.send(workerReceivePort.sendPort);

    workerReceivePort.listen((message) {
      if (message is List) {
        final int id = message[0];
        final String text = message[1];
        final int voice = message[2];
        final String lang = message[3];
        final int numSteps = message[4];

        try {
          final preparedText = lang == 'ru' ? stressDic.addStress(text) : text;
          final audio = tts.generateWithConfig(
            text: preparedText,
            config: OfflineTtsGenerationConfig(
              sid: voice,
              speed: (voice == 1 || voice == 7) ? 1 : 1.2,
              extra: {'lang': lang, 'num_steps': numSteps},
            ),
          );

          final wavBytes = _samplesToWavBytes(audio.samples, audio.sampleRate);


          mainSendPort.send([id, wavBytes]);
        } catch (_) {
          mainSendPort.send([id, null]);
        }
      }
    });
  }

  static Uint8List _samplesToWavBytes(Float32List samples, int sampleRate) {
    final numSamples = samples.length;
    final dataSize = numSamples * 2; // 16-bit PCM = 2 bytes per sample
    final byteData = ByteData(44 + dataSize);

    void writeString(int offset, String value) {
      for (int i = 0; i < value.length; i++) {
        byteData.setUint8(offset + i, value.codeUnitAt(i));
      }
    }

    // RIFF/WAV (44 bytes)
    writeString(0, 'RIFF');
    byteData.setUint32(4, 36 + dataSize, Endian.little);
    writeString(8, 'WAVE');
    writeString(12, 'fmt ');
    byteData.setUint32(16, 16, Endian.little); // PCM chunk size
    byteData.setUint16(20, 1, Endian.little); // Audio format = 1 (PCM)
    byteData.setUint16(22, 1, Endian.little); // Num channels = 1 (mono)
    byteData.setUint32(24, sampleRate, Endian.little);
    byteData.setUint32(28, sampleRate * 2, Endian.little); // Byte rate
    byteData.setUint16(32, 2, Endian.little); // Block align
    byteData.setUint16(34, 16, Endian.little); // Bits per sample = 16
    writeString(36, 'data');
    byteData.setUint32(40, dataSize, Endian.little);

    // Convert Float32 [-1.0, 1.0] to Int16
    for (int i = 0; i < numSamples; i++) {
      final clamped = samples[i].clamp(-1.0, 1.0);
      final int16 = (clamped * 32767).round();
      byteData.setInt16(44 + i * 2, int16, Endian.little);
    }

    return byteData.buffer.asUint8List();
  }

  static OfflineTts _createTts(TTSModelsPath path) {
    final supertonicConfig = OfflineTtsSupertonicModelConfig(
      durationPredictor: path.predictor,
      textEncoder: path.textEncoder,
      vectorEstimator: path.vectorEstimator,
      vocoder: path.vocoder,
      ttsJson: path.tts,
      unicodeIndexer: path.unicodeIndexer,
      voiceStyle: path.voice,
    );

    final modelConfig = OfflineTtsModelConfig(
      supertonic: supertonicConfig,
      numThreads: 6,
      provider: 'cpu',
      debug: false,
    );

    final ttsConfig = OfflineTtsConfig(model: modelConfig, maxNumSentences: 1);

    return OfflineTts(ttsConfig);
  }
}