import 'package:den_ai/models/models.dart';
import 'package:den_ai/widgets/message_bubble.dart';
import 'package:den_ai/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';

class UserMessage extends StatelessWidget {
  final UserCard? card;
  final Message message;
  final Function(Message message)? onEditMessage;
  final Function(int messageId)? onDeleteMessage;
  final bool isDesktop;

  const UserMessage({
    super.key,
    this.card,
    required this.message,
    this.onEditMessage,
    this.onDeleteMessage,
    this.isDesktop = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final btnConstraints = isDesktop
        ? BoxConstraints(minWidth: 16, minHeight: 16)
        : BoxConstraints(minWidth: 36, minHeight: 36);
    final borderRadius = isDesktop ? 12.0 : 8.0;
    final shrinkWrap = IconButton.styleFrom(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashFactory: NoSplash.splashFactory,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
    final gap = 8.0;
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
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit, size: 16, color: theme.hintColor),
                      constraints: btnConstraints,
                      style: shrinkWrap,
                      onPressed: onEditMessage != null ? () => onEditMessage?.call(message) : null,
                    ),
                  ),
                  SizedBox(width: gap),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.delete_outline, size: 16, color: Colors.red.shade400),
                      constraints: btnConstraints,
                      style: shrinkWrap,
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
        if (isDesktop) ...[SizedBox(width: gap), PersonaAvatar(card, size: 55)],
      ],
    );
  }
}
