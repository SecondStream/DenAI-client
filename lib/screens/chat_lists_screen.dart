import 'package:chat_bot_client/application/config.dart';
import 'package:chat_bot_client/application/l10n.dart';
import 'package:chat_bot_client/application/routes.dart';
import 'package:chat_bot_client/blocs/chat_list/chat_list_bloc.dart';
import 'package:chat_bot_client/extensions/navigation_ext.dart';
import 'package:chat_bot_client/screens/chat_screen.dart';
import 'package:chat_bot_client/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  final avatarUrl = chat.char.getAvatar(AppConfig.of(context).baseUrl);
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: theme.cardColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                        backgroundImage: avatarUrl == null ? null : NetworkImage(avatarUrl),
                        child: avatarUrl == null
                            ? Text(
                                chat.char.name[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              )
                            : null,
                      ),
                      title: Text(chat.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        chat.messages.isNotEmpty ? chat.messages.last.content : loc.noLastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () {
                        context
                            .push(AppRoutes.chat, arguments: ChatScreenArgs(chatId: chat.id))
                            .then((_) {
                              if (context.mounted) {
                                context.read<ChatsListBloc>().add(LoadAllChatsEvent());
                              }
                            });
                      },
                    ),
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
}
