part of 'menu_bloc.dart';


abstract class MenuState extends BaseState {}

class MenuInitial extends MenuState {}

class MenuInProgress extends MenuState {}

class MenuSuccess extends MenuState {
  final MenuResponse menuResponse;

  MenuSuccess({
    required this.menuResponse,
  });
}

class MenuEditSuccess extends MenuState {}

class MenuCreateSuccess extends MenuState {}

class MenuDeleteSuccess extends MenuState {}

class MenuError extends MenuState {
  final String? error;

  MenuError(
    this.error,
  );
}
