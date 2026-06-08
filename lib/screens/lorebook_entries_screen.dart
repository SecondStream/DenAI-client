import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/widgets/dialogs/lore_entry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:den_ai/blocs/lorebook_entries/lorebook_entries_bloc.dart';
import 'package:den_ai/blocs/lorebook_entries/lorebook_entries_event.dart';
import 'package:den_ai/blocs/lorebook_entries/lorebook_entries_state.dart';
import 'package:den_ai/models/models.dart';

class LorebookEntriesScreen extends StatelessWidget {
  final int bookId;

  const LorebookEntriesScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);

    return BlocProvider<LorebookEntriesBloc>(
      create: (context) => LorebookEntriesBloc(GetIt.instance.get())..add(LoadEntriesEvent(bookId)),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<LorebookEntriesBloc, LorebookEntriesState>(
            builder: (context, state) {
              if (state is LorebookEntriesLoadedState) {
                return Text(state.lorebook.name);
              }
              return Text(loc.loadingChronicles);
            },
          ),
          actions: [
            BlocBuilder<LorebookEntriesBloc, LorebookEntriesState>(
              builder: (context, state) {
                if (state is! LorebookEntriesLoadedState) return const SizedBox();
                return IconButton(
                  icon: const Icon(Icons.add, size: 28, color: Colors.white),
                  onPressed: () => _openEntryEditor(context, bookId, null),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<LorebookEntriesBloc, LorebookEntriesState>(
          builder: (context, state) {
            if (state is LorebookEntriesLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LorebookEntriesErrorState) {
              return Center(
                child: Text(state.error, style: const TextStyle(color: Colors.red)),
              );
            }
            if (state is LorebookEntriesLoadedState) {
              final entries = state.lorebook.entries;

              if (entries.isEmpty) {
                return Center(
                  child: Text(
                    loc.noLorebookEntries,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, height: 1.4),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: theme.cardColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                        child: Text(
                          "#${index + 1}",
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        entry.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                      onTap: () => _openEntryEditor(context, bookId, entry),
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

  Future<void> _openEntryEditor(BuildContext context, int bId, LoreEntry? existingEntry) async {
    final entriesBloc = context.read<LorebookEntriesBloc>();

    final LoreEntryIn? result = await LoreEntryDialog.open(context, bId, entry: existingEntry);

    if (result == null) return;

    if (result.id == -1 && existingEntry != null) {
      entriesBloc.add(DeleteEntryEvent(existingEntry.id));
    } else {
      entriesBloc.add(SaveEntryEvent(result));
    }
  }
}
