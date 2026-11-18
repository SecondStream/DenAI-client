import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/blocs/chat/chat_bloc.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/extensions/responsive_context.dart';
import 'package:den_ai/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeCardDialog extends StatelessWidget {
  final ChatBloc bloc;
  const ChangeCardDialog({super.key, required this.bloc});

  static Future<void> open(BuildContext context, ChatBloc bloc, bool isDesktop) {
    return isDesktop
        ? showDialog(
            context: context,
            builder: (context) => Dialog(
              child: SizedBox(width: 500, child: ChangeCardDialog(bloc: bloc)),
            ),
          )
        : showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: SizedBox(child: ChangeCardDialog(bloc: bloc)),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (context.isMobile)
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            else
              const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.person_outline, color: theme.colorScheme.primary, size: 22),
                const SizedBox(width: 10),
                Text(loc.selectRoleText, style: TextStyle(fontSize: 20, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 12),
            BlocBuilder<ChatBloc, ChatState>(
              bloc: bloc,
              builder: (context, dialogState) {
                if (dialogState is! ChatLoadedState) return const SizedBox();

                final cards = dialogState.availableCards;

                if (cards == null) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (cards.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(loc.noRolesText, textAlign: TextAlign.center),
                  );
                }

                return Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      final isCurrent = dialogState.userCard?.id == card.id;

                      return Card(
                        color: isCurrent
                            ? theme.colorScheme.primary.withValues(alpha: 0.2)
                            : theme.cardColor,
                        child: ListTile(
                          leading: PersonaAvatar(card, size: 40),
                          title: Text(
                            card.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: isCurrent
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : null,
                          onTap: () {
                            bloc.add(ChangeUserCardEvent(card.id));
                            context.pop();
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
