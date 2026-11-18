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
  final bool isDesktop;

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
    this.isDesktop = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    final player = this.player;
    final borderRadius = isDesktop ? 12.0 : 8.0;
    final btnConstraints = isDesktop
        ? BoxConstraints(minWidth: 16, minHeight: 16)
        : BoxConstraints(minWidth: 36, minHeight: 36);
    final shrinkWrap = IconButton.styleFrom(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashFactory: NoSplash.splashFactory,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
    final gap = 8.0;
    final iconSize = isDesktop ? 16.0 : 16.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isDesktop) ...[PersonaAvatar(char, size: 55), SizedBox(width: 8)],
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (message.id > 0) ...[
                        if (onSwitchMessage != null && message.totalVariants > 1) ...[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_left,
                                    size: iconSize,
                                    color: theme.hintColor,
                                  ),
                                  constraints: btnConstraints,
                                  style: shrinkWrap,
                                  onPressed: onSwitchMessage != null
                                      ? () =>
                                            onSwitchMessage?.call(message.id, MessageDirection.left)
                                      : null,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  "${message.currentIndex} / ${message.totalVariants}",
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: isDesktop ? 11 : 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_right,
                                    size: iconSize,
                                    color: theme.hintColor,
                                  ),
                                  constraints: btnConstraints,
                                  style: shrinkWrap,
                                  onPressed: onSwitchMessage != null
                                      ? () => onSwitchMessage?.call(
                                          message.id,
                                          MessageDirection.right,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: gap),
                        ],
                        if (onRegenerateMessage != null) ...[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.refresh, size: iconSize, color: theme.hintColor),
                              constraints: btnConstraints,
                              style: shrinkWrap,
                              onPressed: () => onRegenerateMessage?.call(message.id),
                            ),
                          ),
                          SizedBox(width: gap),
                        ],
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.edit, size: iconSize, color: theme.hintColor),
                            constraints: btnConstraints,
                            style: shrinkWrap,
                            onPressed: onEditMessage != null
                                ? () => onEditMessage?.call(message)
                                : null,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (player != null &&
                          (message.id > 0 || message.id == Consts.greetingTmp)) ...[
                        ValueListenableBuilder<bool>(
                          valueListenable: player.isAutoEnabled,
                          builder: (context, value, child) {
                            return Container(
                              decoration: BoxDecoration(
                                color: value
                                    ? theme.colorScheme.primary.withValues(alpha: 0.5)
                                    : Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(borderRadius),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.hdr_auto_rounded,
                                  size: iconSize,
                                  color: value ? theme.cardColor : theme.hintColor,
                                ),
                                constraints: btnConstraints,
                                style: shrinkWrap,
                                onPressed: () => player.changeAutoTts(!value),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: gap),
                        ValueListenableBuilder<int?>(
                          valueListenable: player.activeMessageId,
                          builder: (context, value, child) {
                            final isCurrentPlay = value != null && value == message.id;
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(borderRadius),
                              ),
                              child: IconButton(
                                icon: isCurrentPlay
                                    ? Icon(Icons.stop, size: iconSize, color: theme.hintColor)
                                    : Icon(
                                        Icons.play_arrow,
                                        size: iconSize,
                                        color: theme.hintColor,
                                      ),
                                style: shrinkWrap,
                                constraints: btnConstraints,
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
            ],
          ),
        ),
      ],
    );
  }
}
