import 'package:den_ai/application/config.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class CharacterMessage extends StatelessWidget {
  final Char char;
  final Message message;
  final bool isThinking;
  final Function(Message message)? onEditMessage;
  final Function(int messageId, MessageDirection direction)? onSwitchMessage;
  final Function(int messageId)? onRegenerateMessage;

  const CharacterMessage({
    super.key,
    required this.char,
    required this.message,
    this.isThinking = false,
    this.onEditMessage,
    this.onSwitchMessage,
    this.onRegenerateMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    final String? charAvatar = char.getAvatar(AppConfig.of(context).baseUrl);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          backgroundImage: charAvatar == null ? null : NetworkImage(charAvatar),
          child: charAvatar == null
              ? Text(
                  char.name.toUpperCase(),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                )
              : null,
        ),
        const SizedBox(width: 8),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MessageBubble(
              position: MessagePosition.left,
              message: isThinking && message.content.isEmpty
                  ? loc.charThinking(char.name)
                  : message.content,
            ),

            if (message.id > 0) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.totalVariants > 1) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_left, size: 20, color: Colors.grey),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: onSwitchMessage != null
                                ? () => onSwitchMessage?.call(message.id, MessageDirection.left)
                                : null,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${message.currentIndex} / ${message.totalVariants}",
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.arrow_right, size: 20, color: Colors.grey),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: onSwitchMessage != null
                                ? () => onSwitchMessage?.call(message.id, MessageDirection.right)
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (onRegenerateMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.refresh, size: 16, color: theme.colorScheme.primary),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(2),
                        onPressed: () => onRegenerateMessage?.call(message.id),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 14, color: Colors.grey),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(2),
                      onPressed: onEditMessage != null ? () => onEditMessage?.call(message) : null,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}
