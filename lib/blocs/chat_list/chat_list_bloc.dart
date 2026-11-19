import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/application/logger.dart';
import 'package:den_ai/blocs/notify/notify_bloc.dart';
import 'package:den_ai/consts/consts.dart';
import 'package:den_ai/models/character_card.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/repositories/characters_repository.dart';
import 'package:den_ai/repositories/chats_repository.dart';
import 'package:den_ai/repositories/statistics_repository.dart';
import 'package:den_ai/tools/file_tool.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatsListBloc extends Bloc<ChatsListEvent, ChatsListState> {
  final ChatsRepository _repository;
  final StatisticsRepository _statRepository;
  final CharactersRepository _charsRepository;
  final ChatsRepository _chatsRepository;
  final NotifyBloc _notification;

  ChatsListBloc(this._repository, this._notification, this._statRepository, this._charsRepository, this._chatsRepository)
    : super(ChatsListInitialState()) {
    on<ChatListShownEvent>(_onShown);
    on<LoadAllChatsEvent>(_onLoadAllChats);
    on<DeleteChatEvent>(_onDeleteChat);
  }

  void _onShown(ChatListShownEvent event, Emitter<ChatsListState> emit) async {
    emit(ChatsListLoadingState());
    try {
      try {
        final stat = await _statRepository.getAll();
        if (stat.appLaunchCount <= 1) {
          if (!_charsRepository.defaultCreated) {
            final chars = await _charsRepository.getCharacters();
            if (chars.isEmpty) {
              final charData = event.getLocalizedChar(Consts.defaultChar);
              if (charData != null) {
                final avatar = await rootBundle.load(charData.avatar);
                final ext = charData.avatar.split('.').last;
                final avatarPath = await FileTool.saveAvatarBytes(avatar.buffer.asUint8List(), ext);
                final bg = await rootBundle.load(charData.background);
                final extBg = charData.background.split('.').last;
                final backgroundPath = await FileTool.saveBackgroundBytes(bg.buffer.asUint8List(), extBg);
                final char = await _charsRepository.saveCharacter(
                  name: charData.name,
                  appearance: charData.description,
                  personality: charData.personality,
                  scenario: charData.scenario,
                  greeting: charData.greeting,
                  prompt: charData.instructions,
                  notes: charData.notes,
                  lorebookIds: [],
                  isDefault: true,
                  avatarPath: avatarPath,
                  backgroundPath: backgroundPath,
                );

                await _chatsRepository.createNewChat(char.id, null, null);
              }
            }
          }
        }
      } catch (e, st) {
        AppLogger.error('Create default character error', error: e, stackTrace: st);
      }
      final chats = await _repository.getChats();
      emit(ChatsListLoadedState(chats));
    } catch (e, st) {
      _notification.add(ErrorOccurredEvent(type: ErrType.loadChats, error: e, stackTrace: st));
      emit(ChatsListLoadedState([]));
    }
  }

  void _onLoadAllChats(LoadAllChatsEvent event, Emitter<ChatsListState> emit) async {
    emit(ChatsListLoadingState());
    try {
      final chats = await _repository.getChats();
      emit(ChatsListLoadedState(chats));
    } catch (e, st) {
      _notification.add(ErrorOccurredEvent(type: ErrType.loadChats, error: e, stackTrace: st));
      emit(ChatsListLoadedState([]));
    }
  }

  void _onDeleteChat(DeleteChatEvent event, Emitter<ChatsListState> emit) async {
    if (state is! ChatsListLoadedState) return;
    final currentState = state as ChatsListLoadedState;

    try {
      await _repository.deleteChat(event.chatId);
      final updatedChats = List<Chat>.from(currentState.chats)
        ..removeWhere((c) => c.id == event.chatId);

      emit(currentState.copyWith(chats: updatedChats));
    } catch (e, st) {
      _notification.add(ErrorOccurredEvent(type: ErrType.deleteChat, error: e, stackTrace: st));
      emit(currentState.copyWith());
    }
  }
}
