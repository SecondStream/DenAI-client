import 'package:den_ai/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';

class ChatActionsMenu extends StatelessWidget {
  final dynamic userCard;
  final bool isBlocked;
  final String roleButtonText;
  final String attachImageText;
  final VoidCallback onChangeRole;
  final VoidCallback onAttachImage;

  const ChatActionsMenu({
    super.key,
    required this.userCard,
    required this.isBlocked,
    required this.roleButtonText,
    required this.attachImageText,
    required this.onChangeRole,
    required this.onAttachImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MenuAnchor(
      alignmentOffset: const Offset(8, 15),
      style: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 8)),
        backgroundColor: WidgetStatePropertyAll(
          theme.appBarTheme.backgroundColor,
        ),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(8),
        shadowColor: const WidgetStatePropertyAll(Colors.black54),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      menuChildren: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PersonaAvatar(userCard, size: 32),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  userCard?.name ?? 'Без роли',
                  style: theme.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 8),

        MenuItemButton(
          leadingIcon: Icon(Icons.person_outline, size: 20, color: isBlocked ? theme.hintColor : null),
          onPressed: isBlocked ? null : onChangeRole,
          child: Text(roleButtonText, style: TextStyle(color: isBlocked ? theme.hintColor : null)),
        ),

        MenuItemButton(
          leadingIcon: Icon(Icons.image_outlined, size: 20, color: isBlocked ? theme.hintColor : null),
          onPressed: isBlocked ? null : onAttachImage,
          child: Text(attachImageText, style: TextStyle(color: isBlocked ? theme.hintColor : null)),
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          icon: Icon(
            controller.isOpen ? Icons.close : Icons.add,
            color: theme.hintColor,
            size: 22,
          ),
          onPressed: isBlocked
              ? null
              : () => controller.isOpen ? controller.close() : controller.open(),
        );
      },
    );
  }
}