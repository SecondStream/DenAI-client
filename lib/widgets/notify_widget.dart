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
    return BlocProvider<NotifyBloc>(
      create: (context) => NotifyBloc(GetIt.instance.get()),
      child: BlocListener<NotifyBloc, NotifyState>(
        listener: (ctx, state) {
          final context = navKey.currentState?.context;
          if (context != null) {
            if (state is NotifyShowErrorState) {
              _showError(context, state.error);
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

  void _showError(BuildContext context, String message) {
    showTopNotification(context, Icon(Icons.error, color: Colors.redAccent, size: 30), message);
  }

  void _showChatMessage(BuildContext context, Char char, String message) {
    showTopNotification(context, PersonaAvatar(char), message);
  }

  void showTopNotification(BuildContext context, Widget icon, String message) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      icon,
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          message,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
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
