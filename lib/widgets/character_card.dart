import 'package:den_ai/application/config.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/extensions/responsive_context.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/widgets/cropped_avatar.dart';
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
    final isDesktop = context.isDesktop;
    return Card(
      color: theme.cardColor,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double cardWidth = constraints.maxWidth;

          return InkWell(
            onTap: () => onPressed(character.id),
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
                            child: Icon(Icons.person, size: 54, color: theme.hintColor),
                          )
                        : CroppedAvatar(
                            imageUrl: avatarUrl,
                            cropData: character.getCropData(),
                            size: cardWidth,
                            isCircle: false,
                          ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        tooltip: loc.editPrompts,
                        icon: Icon(Icons.edit, color: theme.colorScheme.primary, size: 18),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.6),
                          padding: const EdgeInsets.all(8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => onEditPressed(character.id),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(isDesktop ? 12: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        character.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: isDesktop ? 15 : 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: isDesktop ? 6 : 3),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(isDesktop ? 20 : 14),
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
        },
      ),
    );
  }
}
