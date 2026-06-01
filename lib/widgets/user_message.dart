import 'package:chat_bot_client/application/config.dart';
import 'package:chat_bot_client/models/models.dart';
import 'package:chat_bot_client/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class UserMessage extends StatelessWidget {
  final UserCard? card;
  final Message message;
  final Function(Message message)? onEditMessage;
  final Function(int messageId)? onDeleteMessage;

  const UserMessage({
    super.key,
    this.card,
    required this.message,
    this.onEditMessage,
    this.onDeleteMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String? userAvatar = card?.getAvatar(AppConfig.of(context).baseUrl);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MessageBubble(position: MessagePosition.right, message: message.content),
            if (message.id > 0) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.delete_outline, size: 14, color: Colors.red.shade400),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(2),
                      onPressed: onDeleteMessage != null
                          ? () => onDeleteMessage?.call(message.id)
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 25,
          backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.15),
          backgroundImage: userAvatar == null ? null : NetworkImage(userAvatar),
          child: userAvatar == null ? const Icon(Icons.person, size: 18, color: Colors.grey) : null,
        ),
      ],
    );
  }
}
