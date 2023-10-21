part of 'menu_bloc.dart';

abstract class MenuEvent {}

class Menu extends MenuEvent {}

class MenuEdit extends MenuEvent {
  final String name;
  final String id;
  final String nameCreate;
  final String menuOrder;
  final String idMenu;

  MenuEdit({
    required this.name,
    required this.id,
    required this.nameCreate,
    required this.menuOrder,
    required this.idMenu,
  });
}

class MenuCreate extends MenuEvent {
  final String name;
  final String menuOrder;
  final String nameCreate;
  final String id;

  MenuCreate({
    required this.name,
    required this.menuOrder,
    required this.nameCreate,
    required this.id,
  });
}

class MenuDelete extends MenuEvent {
  final String id;

  MenuDelete({
    required this.id,
  });
}
