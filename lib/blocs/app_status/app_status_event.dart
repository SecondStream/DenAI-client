part of 'app_status_bloc.dart';

abstract class AppStatusEvent {}

class AppStartedEvent extends AppStatusEvent {
  AppStartedEvent();
}
