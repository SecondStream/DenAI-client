import 'dart:async';
import 'dart:collection';
import 'package:audioplayers/audioplayers.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/blocs/notify/notify_bloc.dart';
import 'package:den_ai/consts/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:den_ai/tools/tts_tool.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TTSPlayerService {
  static const int _minLength = 5;
  static const int _minFirstLength = 30;
  static const _prefAutoTts = 'tts_auto_enabled';
  static const _prefOnlyDialogue = 'tts_only_dialogue';
  final TTSTool _ttsTool;
  final NotifyBloc notifyBloc;
  final AudioPlayer _player = AudioPlayer();
  final ValueNotifier<int?> activeMessageId = ValueNotifier<int?>(null);
  final SharedPreferences _prefs;
  late final ValueNotifier<bool> isAutoEnabled;
  late final ValueNotifier<bool> onlyDialogue;
  int _sessionId = 0;

  int _spokenCursor = 0;
  bool _isFirstChunk = true;

  final Queue<String> _textQueue = Queue<String>();
  final Queue<Uint8List> _audioQueue = Queue<Uint8List>();

  bool _isGenerating = false;
  bool _isPlaying = false;
  String? _activeVoice;

  TTSPlayerService(this._ttsTool, this.notifyBloc, this._prefs) {
    isAutoEnabled = ValueNotifier<bool>(_prefs.getBool(_prefAutoTts) ?? false);
    onlyDialogue = ValueNotifier<bool>(_prefs.getBool(_prefOnlyDialogue) ?? true);
    _player.onPlayerComplete.listen((_) {
      _isPlaying = false;
      if (_audioQueue.isNotEmpty) {
        _playNextFromQueue();
      } else if (!_isGenerating &&
          _textQueue.isEmpty &&
          (activeMessageId.value == null || activeMessageId.value! > 0)) {
        stop();
      }
    });
  }

  Future<void> changeAutoTts(bool value) async {
    final next = value;
    isAutoEnabled.value = next;
    await _prefs.setBool(_prefAutoTts, next);

    if (!next && activeMessageId.value != null && activeMessageId.value! == Consts.messageTmp) {
      await stop();
    }
  }

  Future<void> changeOnlyDialogue(bool value) async {
    final next = value;
    onlyDialogue.value = next;
    await _prefs.setBool(_prefOnlyDialogue, next);
  }

  void feedStream({required int tempMessageId, required String fullText, required String voice}) {
    if (activeMessageId.value != tempMessageId) {
      stop();
      activeMessageId.value = tempMessageId;
      _activeVoice = voice;
    }

    _extractSentences(fullText, isFinal: false);
  }

  void finishStream({required int realMessageId, required String fullText, required String voice}) {
    if (activeMessageId.value != null && activeMessageId.value! < 0) {
      activeMessageId.value = realMessageId;
    } else if (activeMessageId.value != realMessageId) {
      stop();
      activeMessageId.value = realMessageId;
      _activeVoice = voice;
    }

    _extractSentences(fullText, isFinal: true);
  }

  static final RegExp _roleplayActionRegex = RegExp(
    r'(?:(?<!\*)\*(?<!\s)(.+?)(?:(?<!\s)\*(?!\*)|$))',
    dotAll: true,
  );

  void playMessage({required int messageId, required String fullText, required String voice}) {
    stop();
    final preparedText = onlyDialogue.value
        ? fullText.replaceAll(_roleplayActionRegex, ' ')
        : fullText;

    if (preparedText.trim().isNotEmpty) {
      activeMessageId.value = messageId;
      _activeVoice = voice;
      _extractSentences(preparedText, isFinal: true);
    }
  }

  Future<void> stop() async {
    _sessionId++;
    _spokenCursor = 0;
    _isFirstChunk = true;
    _textQueue.clear();
    _audioQueue.clear();
    _isGenerating = false;
    _isPlaying = false;
    activeMessageId.value = null;
    await _player.stop();
  }

  void _extractSentences(String fullText, {required bool isFinal}) {
    final sentenceEndRegex = RegExp(r'(?<!^)[.!?]+\s+|\n+');

    while (_spokenCursor < fullText.length) {
      final remaining = fullText.substring(_spokenCursor);
      final minLen = _isFirstChunk ? _minFirstLength : _minLength;

      int searchOffset = 0;
      int? acceptedEnd;

      while (true) {
        final match = sentenceEndRegex.firstMatch(remaining.substring(searchOffset));
        if (match == null) break;

        final end = searchOffset + match.end;
        if (remaining.substring(0, end).trim().length >= minLen) {
          acceptedEnd = end;
          break;
        }
        searchOffset = end;
      }

      if (acceptedEnd != null) {
        _enqueueChunk(remaining.substring(0, acceptedEnd));
        _spokenCursor += acceptedEnd;
        _isFirstChunk = false;
      } else if (isFinal) {
        _enqueueChunk(remaining);
        _spokenCursor = fullText.length;
        _isFirstChunk = false;
      } else {
        break;
      }
    }
  }

  void _enqueueChunk(String rawChunk) {
    final clean = rawChunk.trim();
    if (clean.isEmpty || !RegExp(r'[а-яА-ЯёЁa-zA-Z0-9]').hasMatch(clean)) {
      return;
    }

    _textQueue.addLast(clean);
    _pumpGenerator();
  }

  Future<void> _pumpGenerator() async {
    if (_isGenerating || _textQueue.isEmpty) return;
    _isGenerating = true;
    final currentSession = _sessionId;

    while (_textQueue.isNotEmpty && _sessionId == currentSession) {
      final sentence = _textQueue.removeFirst();

      if (sentence.isNotEmpty) {
        final wavBytes = _activeVoice != null
            ? await _ttsTool.generate(text: sentence, voice: _activeVoice!)
            : null;

        if (_sessionId != currentSession) break;

        if (wavBytes != null && wavBytes.isNotEmpty) {
          _audioQueue.addLast(wavBytes);
          _playNextFromQueue();
        } else {
          notifyBloc.add(ErrorOccurredEvent(type: ErrType.tts));
        }
      }
    }

    _isGenerating = false;
  }

  Future<void> _playNextFromQueue() async {
    if (_isPlaying || _audioQueue.isEmpty) return;
    _isPlaying = true;

    final nextBytes = _audioQueue.removeFirst();
    await _player.play(BytesSource(nextBytes));
  }

  void dispose() {
    stop();
    _player.dispose();
    activeMessageId.dispose();
  }
}
