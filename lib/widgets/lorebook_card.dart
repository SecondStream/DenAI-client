import 'package:den_ai/application/config.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/widgets/cropped_avatar.dart';
import 'package:flutter/material.dart';

class LorebookCard extends StatelessWidget {
  final Lorebook lorebook;
  final Function(int id) onPressed;
  final Function(int id) onEditPressed;

  const LorebookCard({
    super.key,
    required this.lorebook,
    required this.onPressed,
    required this.onEditPressed,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    final avatarUrl = lorebook.getAvatar(AppConfig.of(context).baseUrl);
    return Card(
      color: theme.cardColor,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double cardWidth = constraints.maxWidth;

          return InkWell(
            onTap: () => onPressed(lorebook.id),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    avatarUrl == null
                        ? Container(
                            width: cardWidth,
                            height: cardWidth,
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            child: const Icon(Icons.person, size: 54, color: Colors.grey),
                          )
                        : CroppedAvatar(
                            imageUrl: avatarUrl,
                            cropData: lorebook.getCropData(),
                            size: cardWidth,
                            isCircle: false,
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
                            onPressed: () => onEditPressed(lorebook.id),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        lorebook.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
