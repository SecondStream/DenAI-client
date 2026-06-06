import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/application/routes.dart';
import 'package:den_ai/blocs/characters/characters_bloc.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/screens/chat_screen.dart';
import 'package:den_ai/widgets/character_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../widgets/app_drawer.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      childAspectRatio: 0.68,
                    ),
                    itemCount: state.characters.length,
                    itemBuilder: (context, index) {
                      final character = state.characters[index];
                      return CharacterCard(
                        character: character,
                        onPressed: (_) => context.push(
                          AppRoutes.chat,
                          arguments: ChatScreenArgs(charId: character.id),
                        ),
                        onEditPressed: (_) => _onEditCharacterPressed(context, character),
                      );
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

  void _onEditCharacterPressed(BuildContext context, Char character) async {
    final charactersBloc = context.read<CharactersBloc>();

    final hasChanges = await context.push(AppRoutes.characterEdit, arguments: character);
    if (hasChanges == true) {
      charactersBloc.add(LoadAllCharactersEvent());
    }
  }
}
