import 'dart:async';

import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/characters_repository.dart';
import 'package:den_ai/services/chat_generation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notify_event.dart';
part 'notify_state.dart';

class NotifyBloc extends Bloc<NotifyEvent, NotifyState> {
  final ChatGenerationService _generationService;
  final CharactersRepository _charactersRepository;

  StreamSubscription<StreamMessage>? _subscription;

  NotifyBloc(this._generationService, this._charactersRepository) : super(NotifyInitialState()) {
    on<ErrorOccurredEvent>(_onErrorReceived);
    on<ChatReceivedNotifyEvent>(_onChatReceived);
    _subscription = _generationService.allMessagesStream.listen(
      (message) => _onMessageReceived(message),
      cancelOnError: false,
    );
  }

  @override
  Future<void> close() async {
    _subscription?.cancel();
    _subscription = null;
    super.close();
  }

  Future<void> _onMessageReceived(StreamMessage message) async {
    try {
      if (message.status == MessageStatus.completed) {
        final char = await _charactersRepository.getCharacterById(message.charId);
        if (char != null) {
          add(
            ChatReceivedNotifyEvent(
              message: WSMessageChat(char: char, message: message.token),
            ),
          );
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  void _onErrorReceived(ErrorOccurredEvent event, Emitter<NotifyState> emit) {
    emit(NotifyShowErrorState(type: event.type));
  }

  FutureOr<void> _onChatReceived(ChatReceivedNotifyEvent event, Emitter<NotifyState> emit) {
    emit(NotifyShowChatState(char: event.message.char, message: event.message.message));
  }
}
