part of 'drawer_bloc.dart';

abstract class DrawerState {}

class DrawerInitialState extends DrawerState {}

class DrawerLoadSuccessState extends DrawerState {
  final UserCard? userCard;

  DrawerLoadSuccessState(this.userCard);
}
