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
      builder: (context) => const NewChatConfirmationDialog(),
    );
  }

  @override
  State<NewChatConfirmationDialog> createState() => _NewChatConfirmationDialogState();
}

class _NewChatConfirmationDialogState extends State<NewChatConfirmationDialog> {
  bool _deleteCurrent = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.startNewChat,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                loc.confirmNewChat,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () => setState(() => _deleteCurrent = !_deleteCurrent),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          loc.deleteChat,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: _deleteCurrent,
                        activeThumbColor: theme.colorScheme.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (value) {
                          setState(() => _deleteCurrent = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(88, 40),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(8),
                      // ),
                    ),
                    child: Text(
                      loc.no,
                      style: TextStyle(
                        color: theme.hintColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(88, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onPressed: () => context.pop(
                      NewChatConfirmationDialogResult(deleteCurrent: _deleteCurrent),
                    ),
                    child: Text(
                      loc.yes,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
