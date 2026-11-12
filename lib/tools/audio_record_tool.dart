import 'dart:collection';
import 'dart:typed_data';

import 'package:den_ai/tools/file_tool.dart';
import 'package:record/record.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;

class AudioRecordTool {
  final AudioRecorder _recorder;
  final sherpa_onnx.VoiceActivityDetector? _detector;
  final List<double> _recordedSamples = [];
  final List<double> _windowBuffer = [];
  final Queue<Float32List> _preRollQueue = Queue<Float32List>();
  static const int _maxPreRollWindows = 16;
  bool _isRecording = false;
  bool _isWriting = false;
  DateTime? _lastSpeechTime;

  bool get isRecording => _isRecording;

  AudioRecordTool() : _recorder = AudioRecorder(), _detector = _createSmartGateVad();

  void reset() {
    _recordedSamples.clear();
    _windowBuffer.clear();
    _preRollQueue.clear();
    _detector?.clear();
    _isRecording = false;
    _isWriting = false;
    _lastSpeechTime = null;
  }

  Future<void> startRecording() async {
    if (!await _recorder.hasPermission()) return;

    reset();
    _isRecording = true;

    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      ),
    );

    stream.listen((Uint8List chunk) {
      _processChunk(_toFloat32List(chunk));
    });
  }

  Float32List _toFloat32List(Uint8List chunk){
    final byteData = ByteData.sublistView(chunk);
    final numSamples = chunk.length ~/ 2;
    final samples = Float32List(numSamples);
    for (int i = 0; i < numSamples; i++) {
      final int16Sample = byteData.getInt16(i * 2, Endian.little);
      samples[i] = int16Sample / 32768.0;
    }

    return samples;
  }
  void _processChunk(Float32List chunk) {
    final vad = _detector;
    if (vad != null) {
      _windowBuffer.addAll(chunk);

      while (_windowBuffer.length >= 512) {
        final window = Float32List.fromList(_windowBuffer.sublist(0, 512));
        _windowBuffer.removeRange(0, 512);
        vad.acceptWaveform(window);
        final isSpeech = vad.isDetected();

        while (!vad.isEmpty()) {
          vad.pop();
        }

        if (isSpeech) {
          _lastSpeechTime = DateTime.now();

          if (!_isWriting) {
            for (final preWindow in _preRollQueue) {
              _recordedSamples.addAll(preWindow);
            }
            _preRollQueue.clear();
            _isWriting = true;
          }
          _recordedSamples.addAll(window);
        } else {
          if (_isWriting &&
              _lastSpeechTime != null &&
              DateTime
                  .now()
                  .difference(_lastSpeechTime!)
                  .inMilliseconds <= 1000) {
            _recordedSamples.addAll(window);
          } else {
            _isWriting = false;
            _preRollQueue.addLast(window);
            if (_preRollQueue.length > _maxPreRollWindows) {
              _preRollQueue.removeFirst();
            }
          }
        }
      }
    } else {
      _recordedSamples.addAll(chunk);
    }
  }



  Future<Float32List> stopRecording() async {
    await _recorder.stop();
    final list = Float32List.fromList(_recordedSamples);
    reset();
    return list;
  }

  void dispose() {
    reset();
    _detector?.free();
    _recorder.dispose();
  }

  static sherpa_onnx.VoiceActivityDetector? _createSmartGateVad() {
    final path = FileTool.sttModelsPath;
    if (path != null) {
      final config = sherpa_onnx.SileroVadModelConfig(
        model: FileTool.sttModelsPath!.vad,
        threshold: 0.5,
        minSilenceDuration: 0.25,
        minSpeechDuration: 0.1,
        windowSize: 512,
      );

      final vadConfig = sherpa_onnx.VadModelConfig(
        sileroVad: config,
        sampleRate: 16000,
        numThreads: 1,
        provider: 'cpu',
      );

      return sherpa_onnx.VoiceActivityDetector(config: vadConfig, bufferSizeInSeconds: 5);
    }
    return null;
  }
}
