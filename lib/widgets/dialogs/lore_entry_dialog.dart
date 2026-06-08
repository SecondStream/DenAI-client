import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:flutter/material.dart';
import 'package:den_ai/models/models.dart';

class LoreEntryDialog extends StatefulWidget {
  final int bookId;
  final LoreEntry? entry;

  const LoreEntryDialog({super.key, required this.bookId, this.entry});

  static Future<LoreEntryIn?> open(BuildContext context, int bookId, {LoreEntry? entry}) {
    return showDialog<LoreEntryIn>(
      context: context,
      builder: (context) => LoreEntryDialog(bookId: bookId, entry: entry),
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

    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Row(
        children: [
          Icon(
            widget.entry == null ? Icons.playlist_add : Icons.edit_note,
            color: theme.colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(widget.entry == null ? loc.titleAddLorebookEntry : loc.titleEditLorebookEntry),
        ],
      ),
      content: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: loc.loreHintTitle,
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  fillColor: theme.cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? loc.loreErrorTitleEmpty : null,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: TextFormField(
                  controller: _contentController,
                  maxLines: 12,
                  minLines: 8,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                  decoration: InputDecoration(
                    hintText: loc.loreHintContent,
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    fillColor: theme.cardColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? loc.loreErrorContentEmpty : null,
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.entry != null)
              TextButton(
                onPressed: () {
                  context.pop(
                    LoreEntryIn(id: -1, lorebookId: widget.bookId, title: '', content: ''),
                  );
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
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
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
                  child: Text(loc.save, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
