import 'package:den_ai/application/routes.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/models/user_card.dart';
import 'package:den_ai/widgets/user_card_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:den_ai/application/l10n.dart';
import '../blocs/user_cards_list/user_cards_list_bloc.dart';
import '../widgets/app_drawer.dart';

class UserCardsScreen extends StatelessWidget {
  const UserCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      childAspectRatio: 0.68,
                    ),
                    itemCount: state.cards.length,
                    itemBuilder: (context, index) {
                      final card = state.cards[index];
                      return UserCardView(
                        card: card,
                        onPressed: (_) => _onUserCardPressed(context, card),
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

  void _onUserCardPressed(BuildContext context, UserCard card) async {
    final userCardsListBloc = context.read<UserCardsListBloc>();
    final hasChanges = await context.push<bool>(AppRoutes.userCardEdit, arguments: card);
    if (hasChanges == true) {
      userCardsListBloc.add(LoadAllUserCardsEvent());
    }
  }
}
