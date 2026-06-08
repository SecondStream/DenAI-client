import 'package:flutter/material.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/extensions/navigation_ext.dart';

class LorebooksSelectDialog extends StatefulWidget {
  final List<Lorebook> allLorebooks;
  final List<int> initialSelectedIds;

  const LorebooksSelectDialog({
    super.key,
    required this.allLorebooks,
    required this.initialSelectedIds,
  });

  static Future<List<int>?> open(
    BuildContext context,
    List<Lorebook> allLorebooks,
    List<int> initialSelectedIds,
  ) {
    return showDialog<List<int>>(
      context: context,
      builder: (context) =>
          LorebooksSelectDialog(allLorebooks: allLorebooks, initialSelectedIds: initialSelectedIds),
    );
  }

  @override
  State<LorebooksSelectDialog> createState() => _LorebooksSelectDialogState();
}

class _LorebooksSelectDialogState extends State<LorebooksSelectDialog> {
  late List<int> _localSelectedIds;

  @override
  void initState() {
    super.initState();
    _localSelectedIds = List<int>.from(widget.initialSelectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);

    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.library_books, color: Colors.grey, size: 22),
          SizedBox(width: 10),
          Text(
            loc.lorebookSelectionTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        height: 400,
        child: widget.allLorebooks.isEmpty
            ? Center(
                child: Text(
                  loc.noLorebooksWarning,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                ),
              )
            : ListView.builder(
                itemCount: widget.allLorebooks.length,
                itemBuilder: (context, index) {
                  final book = widget.allLorebooks[index];
                  final isChecked = _localSelectedIds.contains(book.id);

                  return Card(
                    color: theme.cardColor,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: CheckboxListTile(
                      title: Text(
                        book.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        book.about,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      value: isChecked,
                      activeColor: theme.colorScheme.primary,
                      checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _localSelectedIds.add(book.id);
                          } else {
                            _localSelectedIds.remove(book.id);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            loc.cancel,
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () => context.pop(_localSelectedIds),
          child: Text(loc.save, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
