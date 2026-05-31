import 'package:chat_bot_client/application/l10n.dart';
import 'package:chat_bot_client/application/routes.dart';
import 'package:chat_bot_client/blocs/chat_list/chat_list_bloc.dart';
import 'package:chat_bot_client/extensions/navigation_ext.dart';
import 'package:chat_bot_client/screens/chat_screen.dart';
import 'package:chat_bot_client/widgets/app_drawer.dart';
import 'package:chat_bot_client/widgets/chat_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization.of(context);

    return BlocProvider<ChatsListBloc>(
      create: (context) => ChatsListBloc(GetIt.instance.get())..add(LoadAllChatsEvent()),
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
                  AppLocalization.of(context).getError(state.errType, state.error),
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is ChatsListLoadedState) {
              if (state.chats.isEmpty) {
                return Center(child: Text(loc.noChats, textAlign: TextAlign.center));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.chats.length,
                itemBuilder: (context, index) {
                  final chat = state.chats[index];

                  return ChatItem(
                    chat: chat,
                    onPressed: (_) {
                      context.push(AppRoutes.chat, arguments: ChatScreenArgs(chatId: chat.id)).then(
                        (_) {
                          if (context.mounted) {
                            context.read<ChatsListBloc>().add(LoadAllChatsEvent());
                          }
                        },
                      );
                    },
                    onRemovePressed: (_) => _onDeleteChat(context, chat.id),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  void _onDeleteChat(BuildContext context, int chatId) async {
    final chatsListBloc = context.read<ChatsListBloc>();
    final res = await _showDeleteChatConfirmation(context);
    if (res == true) chatsListBloc.add(DeleteChatEvent(chatId));
  }

  Future<bool?> _showDeleteChatConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);

    return showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: theme.scaffoldBackgroundColor,
              title: Text(loc.deleteChatDialogTitle, textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      loc.deleteChatDialogMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => dialogContext.pop(),
                        style: TextButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                        child: Text(loc.no),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () => dialogContext.pop(true),
                        child: Text(loc.yes, style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
