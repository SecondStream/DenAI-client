part of 'app_status_bloc.dart';

abstract class AppStatusEvent {}

class AppStartedEvent extends AppStatusEvent {
  AppStartedEvent();
}

class StatusCheckedEvent extends AppStatusEvent {
  StatusCheckedEvent();
}

class ProviderChangedEvent extends AppStatusEvent {
  final int modelsLoadedCode;
  ProviderChangedEvent(this.modelsLoadedCode);
}