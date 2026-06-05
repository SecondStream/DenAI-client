import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:flutter/material.dart';

class NewChatConfirmationDialogResult {
  final bool deleteCurrent;

  NewChatConfirmationDialogResult({required this.deleteCurrent});
}

class NewChatConfirmationDialog extends StatefulWidget {
  const NewChatConfirmationDialog({super.key});

  static Future<NewChatConfirmationDialogResult?> open(BuildContext context) {
    return showDialog<NewChatConfirmationDialogResult>(
      context: context,
      builder: (context) => NewChatConfirmationDialog(),
    );
  }

  @override
  State<StatefulWidget> createState() => _NewChatConfirmationDialogState();
}

class _NewChatConfirmationDialogState extends State<NewChatConfirmationDialog> {
  bool _deleteCurrent = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Text(loc.startNewChat, textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(loc.confirmNewChat, style: TextStyle(color: Colors.white70)),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(loc.deleteChat),
            value: _deleteCurrent,
            activeThumbColor: theme.colorScheme.primary,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            onChanged: (bool value) {
              setState(() {
                _deleteCurrent = value;
              });
            },
          ),
        ],
      ),
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
          onPressed: () =>
              context.pop(NewChatConfirmationDialogResult(deleteCurrent: _deleteCurrent)),
          child: Text(loc.yes, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
