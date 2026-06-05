import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
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
  }) {
    return showDialog(
      context: context,
      builder: (context) => TextEditDialog(
        initText: text,
        title: title,
        description: description,
        hint: hint,
        icon: icon,
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
    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: widget.title != null
          ? Row(
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: theme.colorScheme.primary, size: 22),
                  const SizedBox(width: 10),
                ],
                Text(widget.title!),
              ],
            )
          : null,
      content: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.description != null) ...[
              Text(
                widget.description!,
                style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.3),
              ),
              const SizedBox(height: 16),
            ],

            Flexible(
              child: TextField(
                controller: _controller,
                maxLines: 15,
                minLines: 10,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(color: Colors.grey.shade600),
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
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            loc.cancel,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
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
    );
  }
}
