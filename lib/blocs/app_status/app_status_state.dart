part of 'app_status_bloc.dart';

abstract class AppStatusState {}

class AppStatusInitialState extends AppStatusState {}

class AppStatusErrorState extends AppStatusState {
  AppStatusErrorState();
}

class AppStatusSuccessState extends AppStatusState {
  final bool chatModelAvailable;
  final bool embeddingModelAvailable;
  final bool visionModelAvailable;
  final bool providerAvailable;
  AppStatusSuccessState({
    required this.chatModelAvailable,
    required this.embeddingModelAvailable,
    required this.visionModelAvailable,
    required this.providerAvailable,
  });
}
