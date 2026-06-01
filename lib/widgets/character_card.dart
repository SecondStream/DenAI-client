import 'package:den_ai/application/config.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  final Char character;
  final Function(int charId) onPressed;
  final Function(int charId) onEditPressed;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onPressed,
    required this.onEditPressed,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    final avatarUrl = character.getAvatar(AppConfig.of(context).baseUrl);
    return Card(
      color: theme.cardColor,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                InkWell(
                  onTap: () => onPressed(character.id),
                  child: Container(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    width: double.infinity,
                    height: double.infinity,
                    child: avatarUrl == null
                        ? const Icon(Icons.person, size: 54, color: Colors.grey)
                        : Image.network(avatarUrl, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Tooltip(
                    message: loc.editPrompts,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: Icon(Icons.edit, color: theme.colorScheme.primary, size: 18),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        onPressed: () => onEditPressed(character.id),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  character.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    loc.chat,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
