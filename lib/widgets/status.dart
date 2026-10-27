import 'package:den_ai/blocs/app_status/app_status_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

enum AppStatuses { provider, chat, vision, embedding }

class AppStatus extends InheritedWidget {
  static final Set<AppStatuses> _appStatuses = {};
  bool get providerAvailable => _appStatuses.contains(AppStatuses.provider);
  bool get chatAvailable => _appStatuses.contains(AppStatuses.chat);
  bool get visionAvailable => _appStatuses.contains(AppStatuses.vision);
  bool get embeddingsAvailable => _appStatuses.contains(AppStatuses.embedding);

  AppStatus({super.key, required Widget child}) : super(child: AppStatusWidget(child: child));

  static AppStatus of(BuildContext context) {
    final AppStatus? result = context.dependOnInheritedWidgetOfExactType<AppStatus>();
    assert(result != null, 'No AppStatus found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppStatus oldWidget) => false;

  void _updateStatuses(bool provider, bool chat, bool vision, bool embeddings) {
    provider ? _appStatuses.add(AppStatuses.provider) : _appStatuses.remove(AppStatuses.provider);
    chat ? _appStatuses.add(AppStatuses.chat) : _appStatuses.remove(AppStatuses.chat);
    vision ? _appStatuses.add(AppStatuses.vision) : _appStatuses.remove(AppStatuses.vision);
    embeddings
        ? _appStatuses.add(AppStatuses.embedding)
        : _appStatuses.remove(AppStatuses.embedding);
  }
}

class AppStatusWidget extends StatelessWidget {
  final Widget child;
  const AppStatusWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppStatusBloc(GetIt.instance.get(), GetIt.instance.get())..add(AppStartedEvent()),
      child: BlocListener<AppStatusBloc, AppStatusState>(
        listener: (context, state) {
          if (state is AppStatusSuccessState) {
            AppStatus.of(context)._updateStatuses(
              state.providerAvailable,
              state.chatModelAvailable,
              state.visionModelAvailable,
              state.embeddingModelAvailable,
            );
          }
        },
        child: Builder(builder: (context) => child),
      ),
    );
  }
}
