import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/application/routes.dart';
import 'package:den_ai/blocs/lorebook_list/lorebook_list_bloc.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/widgets/lorebook_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../widgets/app_drawer.dart';

class LorebooksScreen extends StatelessWidget {
  const LorebooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization.of(context);

    return BlocProvider<LorebookListBloc>(
      create: (context) => LorebookListBloc(GetIt.instance.get())..add(LoadAllLorebooksEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(loc.lorebooksTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, size: 28),
                  onPressed: () {
                    context.push(AppRoutes.lorebookEdit).then((hasChanges) {
                      if (hasChanges == true && context.mounted) {
                        context.read<LorebookListBloc>().add(LoadAllLorebooksEvent());
                      }
                    });
                  },
                ),
              ],
            ),
            drawer: const AppDrawer(),

            body: BlocBuilder<LorebookListBloc, LorebookListState>(
              builder: (context, state) {
                if (state is LorebookListLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is LorebookListErrorState) {
                  return Center(
                    child: Text(
                      AppLocalization.of(context).getError(state.errType, state.error),
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is LorebookListLoadedState) {
                  if (state.lorebooks.isEmpty) {
                    return Center(child: Text(loc.noLorebooksMessage, textAlign: TextAlign.center));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: state.lorebooks.length,
                    itemBuilder: (context, index) {
                      final lorebook = state.lorebooks[index];
                      return LorebookCard(
                        lorebook: lorebook,
                        onPressed: (_) =>
                            context.push(AppRoutes.loreEntries, arguments: lorebook.id),
                        onEditPressed: (_) => _onEditPressed(context, lorebook),
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

  void _onEditPressed(BuildContext context, Lorebook lorebook) async {
    final lorebookBloc = context.read<LorebookListBloc>();

    final hasChanges = await context.push(AppRoutes.lorebookEdit, arguments: lorebook);
    if (hasChanges == true) {
      lorebookBloc.add(LoadAllLorebooksEvent());
    }
  }
}
