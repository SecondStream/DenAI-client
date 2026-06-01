import 'package:den_ai/application/config.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:flutter/material.dart';

class UserCardView extends StatelessWidget {
  final UserCard card;
  final Function(int charId) onPressed;

  const UserCardView({super.key, required this.card, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    final avatarUrl = card.getAvatar(AppConfig.of(context).baseUrl);
    return Card(
      color: theme.cardColor,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => onPressed(card.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    width: double.infinity,
                    height: double.infinity,
                    child: avatarUrl == null
                        ? const Icon(Icons.person, size: 54, color: Colors.grey)
                        : Image.network(
                            avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 54, color: Colors.grey),
                          ),
                  ),
                  if (card.isDefault)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star, color: Colors.amber, size: 20),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card.isDefault ? loc.defaultStatus : loc.additionalStatus,
                    style: TextStyle(
                      color: card.isDefault ? theme.colorScheme.primary : Colors.grey,
                      fontWeight: card.isDefault ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
