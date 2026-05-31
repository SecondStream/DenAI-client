import 'package:chat_bot_client/application/l10n.dart';
import 'package:chat_bot_client/models/models.dart';
import 'package:chat_bot_client/repositories/chats_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatsListBloc extends Bloc<ChatsListEvent, ChatsListState> {
  final ChatsRepository _repository;

  ChatsListBloc(this._repository) : super(ChatsListInitialState()) {
    on<LoadAllChatsEvent>(_onLoadAllChats);
    on<DeleteChatEvent>(_onDeleteChat);
  }

  void _onLoadAllChats(LoadAllChatsEvent event, Emitter<ChatsListState> emit) async {
    emit(ChatsListLoadingState());
    try {
      final chats = await _repository.getChats();
      emit(ChatsListLoadedState(chats));
    } catch (e) {
      emit(ChatsListErrorState(ErrType.loadChats, e));
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
    } catch (e) {
      emit(ChatsListErrorState(ErrType.deleteChat, e));
    }
  }
}
