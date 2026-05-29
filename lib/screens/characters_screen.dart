import 'package:chat_bot_client/application/config.dart';
import 'package:chat_bot_client/application/l10n.dart';
import 'package:chat_bot_client/application/routes.dart';
import 'package:chat_bot_client/blocs/characters/characters_bloc.dart';
import 'package:chat_bot_client/extensions/navigation_ext.dart';
import 'package:chat_bot_client/models/models.dart';
import 'package:chat_bot_client/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../widgets/app_drawer.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);

    return BlocProvider<CharactersBloc>(
      create: (context) => CharactersBloc(GetIt.instance.get())..add(LoadAllCharactersEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(loc.charactersTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, size: 28),
                  onPressed: () {
                    context.push(AppRoutes.characterEdit).then((hasChanges) {
                      if (hasChanges == true && context.mounted) {
                        context.read<CharactersBloc>().add(LoadAllCharactersEvent());
                      }
                    });
                  },
                ),
              ],
            ),
            drawer: const AppDrawer(),

            body: BlocBuilder<CharactersBloc, CharactersState>(
              builder: (context, state) {
                if (state is CharactersLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CharactersErrorState) {
                  return Center(
                    child: Text(
                      AppLocalization.of(context).getError(state.errType, state.error),
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is CharactersLoadedState) {
                  if (state.characters.isEmpty) {
                    return Center(
                      child: Text(loc.noCharactersMessage, textAlign: TextAlign.center),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: state.characters.length,
                    itemBuilder: (context, index) {
                      final character = state.characters[index];
                      return _buildCharacterCard(context, loc, theme, character);
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCharacterCard(
    BuildContext context,
    AppLocalization loc,
    ThemeData theme,
    Char character,
  ) {
    final avatarUrl = character.getAvatar(AppConfig.of(context).baseUrl);
    return Card(
      color: theme.cardColor,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                InkWell(
                  onTap: () =>
                      context.push(AppRoutes.chat, arguments: ChatScreenArgs(charId: character.id)),
                  child: Container(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    width: double.infinity,
                    height: double.infinity,
                    child: avatarUrl == null
                        ? const Icon(Icons.person, size: 54, color: Colors.grey)
                        : Image.network(avatarUrl, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Tooltip(
                    message: loc.editPrompts,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: Icon(Icons.edit, color: theme.colorScheme.primary, size: 18),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        onPressed: () async {
                          final charactersBloc = context.read<CharactersBloc>();

                          final hasChanges = await context.push(
                            AppRoutes.characterEdit,
                            arguments: character,
                          );
                          if (hasChanges == true) {
                            charactersBloc.add(LoadAllCharactersEvent());
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  character.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () =>
                      context.push(AppRoutes.chat, arguments: ChatScreenArgs(charId: character.id)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      loc.chat,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
