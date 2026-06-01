import 'package:den_ai/application/config.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final Chat chat;
  final Function(int id) onPressed;
  final Function(int id) onRemovePressed;

  const ChatItem({
    super.key,
    required this.chat,
    required this.onPressed,
    required this.onRemovePressed,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarUrl = chat.char.getAvatar(AppConfig.of(context).baseUrl);
    final loc = AppLocalization.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: theme.cardColor,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          backgroundImage: avatarUrl == null ? null : NetworkImage(avatarUrl),
          child: avatarUrl == null
              ? Text(chat.char.name[0].toUpperCase(), style: const TextStyle(color: Colors.white))
              : null,
        ),
        title: Text(chat.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          chat.messages.isNotEmpty ? chat.messages.last.content : loc.noLastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Tooltip(
          message: loc.deleteChatTooltip,
          child: Transform.translate(
            offset: const Offset(14.0, 0),
            child: IconButton(
              icon: Icon(Icons.delete_outline, size: 24, color: Colors.red.shade400),
              onPressed: () => onRemovePressed(chat.id),
            ),
          ),
        ),

        onTap: () => onPressed(chat.id),
      ),
    );
  }
}
