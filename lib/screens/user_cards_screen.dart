import 'package:chat_bot_client/application/config.dart';
import 'package:chat_bot_client/application/routes.dart';
import 'package:chat_bot_client/extensions/navigation_ext.dart';
import 'package:chat_bot_client/models/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:chat_bot_client/application/l10n.dart';
import '../blocs/user_cards_list/user_cards_list_bloc.dart';
import '../widgets/app_drawer.dart';

class UserCardsScreen extends StatelessWidget {
  const UserCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);

    return BlocProvider<UserCardsListBloc>(
      create: (context) => UserCardsListBloc(GetIt.instance.get())..add(LoadAllUserCardsEvent()),
      child: Builder(
        builder: (childContext) {
          return Scaffold(
            appBar: AppBar(
              title: Text(loc.userCardsTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, size: 28),
                  onPressed: () async {
                    final userCardsListBloc = childContext.read<UserCardsListBloc>();
                    final hasChanges = await context.push<bool>(AppRoutes.userCardEdit);
                    if (hasChanges == true) {
                      userCardsListBloc.add(LoadAllUserCardsEvent());
                    }
                  },
                ),
              ],
            ),
            drawer: const AppDrawer(),
            body: BlocBuilder<UserCardsListBloc, UserCardsListState>(
              builder: (context, state) {
                if (state is UserCardsListLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is UserCardsListErrorState) {
                  return Center(
                    child: Text(
                      AppLocalization.of(context).getError(state.errType, state.error),
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is UserCardsListLoadedState) {
                  if (state.cards.isEmpty) {
                    return Center(child: Text(loc.noUserCardsMessage, textAlign: TextAlign.center));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.70,
                    ),
                    itemCount: state.cards.length,
                    itemBuilder: (context, index) {
                      final card = state.cards[index];
                      return _buildUserCard(context, loc, theme, card);
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

  Widget _buildUserCard(BuildContext context, AppLocalization loc, ThemeData theme, UserCard card) {
    final avatarUrl = card.getAvatar(AppConfig.of(context).baseUrl);
    return Card(
      color: theme.cardColor,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () async {
          final userCardsListBloc = context.read<UserCardsListBloc>();
          final hasChanges = await context.push<bool>(AppRoutes.userCardEdit, arguments: card);
          if (hasChanges == true) {
            userCardsListBloc.add(LoadAllUserCardsEvent());
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    width: double.infinity,
                    height: double.infinity,
                    child: avatarUrl == null
                        ? const Icon(Icons.person, size: 54, color: Colors.grey)
                        : Image.network(
                            avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 54, color: Colors.grey),
                          ),
                  ),
                  if (card.isDefault)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star, color: Colors.amber, size: 20),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card.isDefault ? loc.defaultStatus : loc.additionalStatus,
                    style: TextStyle(
                      color: card.isDefault ? theme.colorScheme.primary : Colors.grey,
                      fontWeight: card.isDefault ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
