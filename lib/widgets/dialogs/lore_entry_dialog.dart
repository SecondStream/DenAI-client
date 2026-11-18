import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/extensions/responsive_context.dart';
import 'package:den_ai/screens/lorebook_entries_screen.dart';
import 'package:flutter/material.dart';
import 'package:den_ai/models/models.dart';

import 'confirmation_dialog.dart';

class LoreEntryDialog extends StatefulWidget {
  final int bookId;
  final LoreEntry? entry;
  final bool readonly;

  const LoreEntryDialog({super.key, required this.bookId, this.entry, this.readonly = false});

  static Future<LoreEntryIn?> open(
    BuildContext context,
    int bookId, {
    LoreEntry? entry,
    bool readonly = false,
  }) {
    return context.isDesktop
        ? showDialog<LoreEntryIn>(
            context: context,
            builder: (context) => Dialog(
              child: SizedBox(
                width: 600,
                child: LoreEntryDialog(bookId: bookId, entry: entry, readonly: readonly),
              ),
            ),
          )
        : showModalBottomSheet<LoreEntryIn>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: LoreEntryDialog(bookId: bookId, entry: entry, readonly: readonly),
            ),
          );
  }

  @override
  State<LoreEntryDialog> createState() => _LoreEntryDialogState();
}

class _LoreEntryDialogState extends State<LoreEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _contentController = TextEditingController(text: widget.entry?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    final isMobile = context.isMobile;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isMobile)
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 8),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              else
                SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    widget.entry == null ? Icons.playlist_add : Icons.edit_note,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.entry == null ? loc.titleAddLorebookEntry : loc.titleEditLorebookEntry,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: loc.loreHintTitle,
                  fillColor: theme.cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? loc.loreErrorTitleEmpty : null,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: TextFormField(
                  controller: _contentController,
                  maxLines: isMobile ? null : 12,
                  minLines: isMobile ? 5 : 8,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                  decoration: InputDecoration(
                    hintText: loc.loreHintContent,
                    fillColor: theme.cardColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? loc.loreErrorContentEmpty : null,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.entry != null && !widget.readonly)
                    TextButton(
                      onPressed: () async {
                        final res = await ConfirmationDialog.open(
                          context,
                          loc.removeLoreEntryConfirmTitle,
                          loc.removeLoreEntryConfirmMessage,
                        );
                        if (res == true && context.mounted) {
                          context.pop(
                            LoreEntryIn(id: -1, lorebookId: widget.bookId, title: '', content: ''),
                          );
                        }
                      },
                      child: Text(
                        loc.delete,
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          loc.cancel,
                          style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (!widget.readonly) ...[
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.pop(
                                LoreEntryIn(
                                  id: widget.entry?.id,
                                  lorebookId: widget.bookId,
                                  title: _titleController.text.trim(),
                                  content: _contentController.text.trim(),
                                ),
                              );
                            }
                          },
                          child: Text(
                            loc.save,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
