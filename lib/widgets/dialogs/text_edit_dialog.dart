import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/extensions/responsive_context.dart';
import 'package:flutter/material.dart';

class TextEditDialog extends StatefulWidget {
  final String initText;
  final String? title;
  final String? description;
  final String? hint;
  final IconData? icon;

  const TextEditDialog({
    super.key,
    required this.initText,
    this.title,
    this.description,
    this.hint,
    this.icon,
  });
  @override
  State<StatefulWidget> createState() => _TextEditDialogState();

  static Future<String?> open(
    BuildContext context,
    String text, {
    String? title,
    String? description,
    String? hint,
    IconData? icon,
    bool isDesktop = true,
  }) {
    return isDesktop
        ? showDialog(
            context: context,
            builder: (context) => Dialog(
              child: SizedBox(
                width: 600,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: TextEditDialog(
                    initText: text,
                    title: title,
                    description: description,
                    hint: hint,
                    icon: icon,
                  ),
                ),
              ),
            ),
          )
        : showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: TextEditDialog(
                initText: text,
                title: title,
                description: description,
                hint: hint,
                icon: icon,
              ),
            ),
          );
  }
}

class _TextEditDialogState extends State<TextEditDialog> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initText);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    final isMobile = context.isMobile;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
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
              ),
            if (widget.title != null) ...[
              Row(
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: theme.colorScheme.primary, size: 22),
                    const SizedBox(width: 10),
                  ],
                  Text(widget.title!, style: TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 12),
            ],
            if (widget.description != null && !isMobile) ...[
              Text(
                widget.description!,
                style: TextStyle(color: theme.hintColor, fontSize: 13, height: 1.3),
              ),
              const SizedBox(height: 16),
            ],

            Flexible(
              child: TextField(
                controller: _controller,
                maxLines: isMobile ? null : 15,
                minLines: isMobile ? 5 : 10,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  fillColor: theme.cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                  onPressed: () => context.pop(_controller.text.trim()),
                  child: Text(loc.save, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
