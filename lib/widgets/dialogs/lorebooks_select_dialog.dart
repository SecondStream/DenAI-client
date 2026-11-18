import 'package:den_ai/extensions/responsive_context.dart';
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
    bool isDesktop,
  ) {
    return isDesktop
        ? showDialog<List<int>>(
            context: context,
            builder: (context) => Dialog(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 450, maxWidth: 500),
                child: LorebooksSelectDialog(
                    allLorebooks: allLorebooks,
                    initialSelectedIds: initialSelectedIds,
                  ),
              ),
            ),
          )
        : showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (context) => ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
              child: LorebooksSelectDialog(
                allLorebooks: allLorebooks,
                initialSelectedIds: initialSelectedIds,
              ),
            ),
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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            if (context.isMobile)
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
                Icon(Icons.library_books, color: theme.colorScheme.primary, size: 22),
                const SizedBox(width: 10),
                Text(
                  loc.lorebookSelectionTitle,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.allLorebooks.isEmpty)
              Center(
                child: Text(
                  loc.noLorebooksWarning,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.hintColor, fontSize: 13, height: 1.4),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          book.about,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: theme.hintColor, fontSize: 12),
                        ),
                        value: isChecked,
                        activeColor: theme.colorScheme.primary,
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
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
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    loc.cancel,
                    style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 8),
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
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
