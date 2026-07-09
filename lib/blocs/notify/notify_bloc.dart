import 'dart:async';
import 'dart:convert';

import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/provider/remote_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';

part 'notify_event.dart';
part 'notify_state.dart';

class NotifyBloc extends Bloc<NotifyEvent, NotifyState> {
  final RemoteProvider remote;
  IOWebSocketChannel? _channel;
  StreamSubscription? _subscription;
  bool _isIntentionalClose = false;
  Timer? _timer;

  NotifyBloc(this.remote) : super(NotifyInitialState()) {
    _connect();
    on<ErrorReceivedNotifyEvent>(_onErrorReceived);
    on<ChatReceivedNotifyEvent>(_onChatReceived);
  }

  @override
  Future<void> close() async {
    _isIntentionalClose = true;
    _cleanup();
    super.close();
  }

  Future<void> _connect() async {
    try {
      final channel = _channel = await remote.wsConnect('/ws/client_id');
      _subscription = channel.stream.listen(
            (message) => _onMessageReceived(jsonDecode(message)),
        onError: (error) => _handleReconnect(),
        onDone: () => _handleReconnect(),
      );
    } catch (_) {
      _handleReconnect();
    }
  }

  Future<void> _onMessageReceived(Map<String, dynamic> message) async {
    if (message['type'] != null && message['payload'] != null) {
      if (message['type'] == WSType.error.name) {
        add(ErrorReceivedNotifyEvent(message: WSMessageError.fromJson(message['payload'])));
      }

      if (message['type'] == WSType.message.name) {
        add(ChatReceivedNotifyEvent(message: WSMessageChat.fromJson(message['payload'])));
      }
    }
  }

  void _handleReconnect() {
    if (_isIntentionalClose) return;
    _cleanup();
    _timer = Timer(const Duration(seconds: 10), _connect);
  }

  void _cleanup() {
    _timer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
  }

  void _onErrorReceived(ErrorReceivedNotifyEvent event, Emitter<NotifyState> emit) {
    emit(NotifyShowErrorState(error: event.message.message));
  }

  FutureOr<void> _onChatReceived(ChatReceivedNotifyEvent event, Emitter<NotifyState> emit) {
    emit(NotifyShowChatState(char: event.message.char, message: event.message.message));
  }
}
