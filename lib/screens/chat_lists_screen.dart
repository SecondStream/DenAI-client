import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/application/routes.dart';
import 'package:den_ai/blocs/chat_list/chat_list_bloc.dart';
import 'package:den_ai/blocs/notify/notify_bloc.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/screens/chat_screen.dart';
import 'package:den_ai/widgets/app_drawer.dart';
import 'package:den_ai/widgets/chat_item.dart';
import 'package:den_ai/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization.of(context);

    return BlocProvider<ChatsListBloc>(
      create: (context) =>
          ChatsListBloc(GetIt.instance.get())..add(LoadAllChatsEvent()),
      child: Builder(
        builder: (context) {
          return BlocListener<NotifyBloc, NotifyState>(
            listener: (context, state) {
              if (state is NotifyShowChatState) {
                context.read<ChatsListBloc>().add(LoadAllChatsEvent());
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(loc.chatsListTitle),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white, size: 28),
                    onPressed: () => context.replace(AppRoutes.characters),
                  ),
                ],
              ),
              drawer: AppDrawer(),

              body: BlocBuilder<ChatsListBloc, ChatsListState>(
                builder: (context, state) {
                  if (state is ChatsListLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatsListErrorState) {
                    return Center(
                      child: Text(
                        AppLocalization.of(
                          context,
                        ).getError(state.errType, state.error),
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state is ChatsListLoadedState) {
                    if (state.chats.isEmpty) {
                      return Center(
                        child: Text(loc.noChats, textAlign: TextAlign.center),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        final chat = state.chats[index];

                        return ChatItem(
                          chat: chat,
                          onPressed: (_) {
                            context
                                .push(
                                  AppRoutes.chat,
                                  arguments: ChatScreenArgs(chatId: chat.id),
                                )
                                .then((_) {
                                  if (context.mounted) {
                                    context.read<ChatsListBloc>().add(
                                      LoadAllChatsEvent(),
                                    );
                                  }
                                });
                          },
                          onRemovePressed: (_) =>
                              _onDeleteChat(context, loc, chat.id),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _onDeleteChat(
    BuildContext context,
    AppLocalization loc,
    int chatId,
  ) async {
    final chatsListBloc = context.read<ChatsListBloc>();
    final res = await ConfirmationDialog.open(
      context,
      loc.deleteChatDialogTitle,
      loc.deleteChatDialogMessage,
    );
    if (res == true) chatsListBloc.add(DeleteChatEvent(chatId));
  }
}
