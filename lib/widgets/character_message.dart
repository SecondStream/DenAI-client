import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/blocs/chat/chat_bloc.dart';
import 'package:den_ai/consts/consts.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/services/tts_player_service.dart';
import 'package:den_ai/widgets/message_bubble.dart';
import 'package:den_ai/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';

class CharacterMessage extends StatelessWidget {
  final Char char;
  final MessageView message;
  final bool isThinking;
  final TTSPlayerService? player;
  final Function(Message message)? onEditMessage;
  final Function(int messageId, MessageDirection direction)? onSwitchMessage;
  final Function(int messageId)? onRegenerateMessage;
  final Function(int messageId)? onPlayTTS;

  const CharacterMessage({
    super.key,
    required this.char,
    required this.message,
    required this.player,
    this.isThinking = false,
    this.onEditMessage,
    this.onSwitchMessage,
    this.onRegenerateMessage,
    this.onPlayTTS,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    final player = this.player;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PersonaAvatar(char, size: 55),
        const SizedBox(width: 8),
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //   child: Text(message.modelName, style: TextStyle(fontSize: 10)),
              // ),
              MessageBubble(
                position: MessagePosition.left,
                message: isThinking && message.content.isEmpty
                    ? loc.charThinking(char.name)
                    : message.content,
              ),

              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (message.id > 0) ...[
                    if (onSwitchMessage != null && message.totalVariants > 1) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_left, size: 20, color: theme.hintColor),
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
                              icon: Icon(Icons.arrow_right, size: 20, color: theme.hintColor),
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
                          color: Colors.black.withValues(alpha: 0.5),
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
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit, size: 16, color: theme.hintColor),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(2),
                        onPressed: onEditMessage != null
                            ? () => onEditMessage?.call(message)
                            : null,
                      ),
                    ),
                  ],
                  Spacer(),
                  if (player != null && (message.id > 0 || message.id == Consts.greetingTmp)) ...[
                    ValueListenableBuilder<bool>(
                      valueListenable: player.isAutoEnabled,
                      builder: (context, value, child) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: value
                                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                                : Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.hdr_auto_rounded,
                              size: 16,
                              color: value ? theme.cardColor : theme.hintColor,
                            ),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(2),
                            onPressed: () => player.changeAutoTts(!value),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ValueListenableBuilder<int?>(
                      valueListenable: player.activeMessageId,
                      builder: (context, value, child) {
                        final isCurrentPlay = value != null && value == message.id;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: isCurrentPlay
                                ? Icon(Icons.stop, size: 16, color: theme.hintColor)
                                : Icon(Icons.play_arrow, size: 16, color: theme.hintColor),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(2),
                            onPressed: () => onPlayTTS?.call(message.id),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
