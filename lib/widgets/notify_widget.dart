import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/application/routes.dart';
import 'package:den_ai/blocs/notify/notify_bloc.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/widgets/persona_avatar.dart';
import 'package:den_ai/widgets/top_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class NotifyWidget extends StatelessWidget {
  final Widget? child;
  final GlobalKey<NavigatorState> navKey;

  const NotifyWidget({super.key, required this.navKey, required this.child});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization.of(context);
    return BlocProvider<NotifyBloc>(
      create: (context) => NotifyBloc(GetIt.instance.get(), GetIt.instance.get()),
      child: BlocListener<NotifyBloc, NotifyState>(
        listener: (ctx, state) {
          final context = navKey.currentState?.context;
          if (context != null) {
            if (state is NotifyShowErrorState) {
              _showError(context, loc, state.type);
            } else if (state is NotifyShowChatState) {
              final currentRoute = GetIt.instance.get<AppRouteObserver>().currentRouteName;
              if (currentRoute != AppRoutes.chat) {
                _showChatMessage(context, state.char, state.message);
              }
            }
          }
        },
        child: child,
      ),
    );
  }

  void _showError(BuildContext context, AppLocalization loc, ErrType type) {
    showTopNotification(context, Icon(Icons.error, color: Colors.redAccent, size: 44), loc.getError(type), isError: true);
  }

  void _showChatMessage(BuildContext context, Char char, String message) {
    showTopNotification(context, PersonaAvatar(char), message);
  }

  void showTopNotification(BuildContext context, Widget icon, String message, {bool isError = false}) {
    final theme = Theme.of(context);
    final overlayState = navKey.currentState?.overlay;
    if (overlayState == null) return;

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 16,
          right: 16,
          left: 16,
          child: TopNotificationWidget(
            onDismissed: () {
              if (overlayEntry.mounted) {
                overlayEntry.remove();
              }
            },
            child: Material(
              color: Colors.transparent,
              child: IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isError ? Colors.redAccent.shade700 : theme.dividerColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        color: isError ? Colors.redAccent.shade700 : theme.dividerColor,
                      ),
                      // Возвращаем внутренние отступы для контента
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              icon,
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  message,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);
  }
}
