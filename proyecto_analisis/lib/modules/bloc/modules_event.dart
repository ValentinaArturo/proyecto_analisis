part of 'modules_bloc.dart';

@immutable
abstract class ModulesEvent {}

class Modules extends ModulesEvent {}

class ModuleEdit extends ModulesEvent {
  final String name;
  final String id;
  final String nameCreate;
  final String menuOrder;

  ModuleEdit({
    required this.name,
    required this.id,
    required this.nameCreate,
    required this.menuOrder,
  });
}

class ModuleCreate extends ModulesEvent {
  final String name;
  final String menuOrder;
  final String nameCreate;

  ModuleCreate({
    required this.name,
    required this.menuOrder,
    required this.nameCreate,
  });
}

class ModuleDelete extends ModulesEvent {
  final String id;

  ModuleDelete({
    required this.id,
  });
}

