import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  const ConfirmationDialog({super.key, required this.title, required this.message});

  static Future<bool?> open(BuildContext context, String title, String message) {
    return showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(title: title, message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Icon(Icons.warning, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          style: TextButton.styleFrom(minimumSize: Size(100, 40)),
          child: Text(
            loc.no,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            minimumSize: Size(100, 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () => context.pop(true),
          child: Text(loc.yes, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
