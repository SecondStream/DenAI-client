import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/extensions/snackbar_ext.dart';
import 'package:den_ai/widgets/placeholder.dart';
import 'package:den_ai/widgets/status.dart';
import 'package:den_ai/widgets/dialogs/lore_entry_dialog.dart';
import 'package:den_ai/widgets/lore_unavailable_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:den_ai/blocs/lorebook_entries/lorebook_entries_bloc.dart';
import 'package:den_ai/blocs/lorebook_entries/lorebook_entries_event.dart';
import 'package:den_ai/blocs/lorebook_entries/lorebook_entries_state.dart';
import 'package:den_ai/models/models.dart';

class LorebookEntriesScreenArgs {
  final int bookId;
  final String bookName;

  LorebookEntriesScreenArgs(this.bookId, this.bookName);
}

class LorebookEntriesScreen extends StatelessWidget {
  final int bookId;
  final String bookName;

  LorebookEntriesScreen({super.key, required LorebookEntriesScreenArgs args})
    : bookId = args.bookId,
      bookName = args.bookName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    final canCreate = AppStatus.of(context).embeddingsAvailable;

    return BlocProvider<LorebookEntriesBloc>(
      create: (context) => LorebookEntriesBloc(
        GetIt.instance.get(),
        GetIt.instance.get(),
        GetIt.instance.get(),
        GetIt.instance.get(),
        context.notifyBloc,
      )..add(LoadEntriesEvent(bookId)),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<LorebookEntriesBloc, LorebookEntriesState>(
            builder: (context, state) {
              return Text(bookName);
            },
          ),
          actions: [
            BlocBuilder<LorebookEntriesBloc, LorebookEntriesState>(
              builder: (context, state) {
                if (state is! LorebookEntriesLoadedState || !canCreate) {
                  return const SizedBox();
                }
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
              final entries = state.entries;

              if (entries.isEmpty) {
                return Column(
                  children: [
                    if (!canCreate) LoreUnavailableBanner(),
                    Expanded(
                      child: EmptyPlaceholder(
                        icon: Icons.developer_board_off_outlined,
                        label: loc.noLorebookEntries,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  if (!canCreate) LoreUnavailableBanner(),
                  Expanded(
                    child: ListView.builder(
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
                            title: Text(
                              entry.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              entry.content,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: theme.hintColor),
                            ),
                            trailing: Icon(Icons.chevron_right, color: theme.hintColor, size: 18),
                            onTap: () =>
                                _openEntryEditor(context, bookId, entry, readonly: !canCreate),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Future<void> _openEntryEditor(
    BuildContext context,
    int bId,
    LoreEntry? existingEntry, {
    bool readonly = false,
  }) async {
    final entriesBloc = context.read<LorebookEntriesBloc>();

    final LoreEntryIn? result = await LoreEntryDialog.open(
      context,
      bId,
      entry: existingEntry,
      readonly: readonly,
    );

    if (result == null) return;

    if (result.id == -1 && existingEntry != null) {
      entriesBloc.add(DeleteEntryEvent(existingEntry.id, bookId));
    } else {
      entriesBloc.add(
        SaveEntryEvent(
          id: result.id,
          lorebookId: result.lorebookId,
          title: result.title,
          content: result.content,
        ),
      );
    }
  }
}

class LoreEntryIn {
  final int? id;
  final int lorebookId;
  final String title;
  final String content;

  LoreEntryIn({
    required this.id,
    required this.lorebookId,
    required this.title,
    required this.content,
  });
}
