part of 'rolrol_bloc.dart';

@immutable
abstract class RolRolEvent {}

class RolRol extends RolRolEvent {}

class RolEdit extends RolRolEvent {
  final String name;
  final int id;
  final String nameCreate;

  RolEdit({
    required this.name,
    required this.id,
    required this.nameCreate,
  });
}

class RolCreate extends RolRolEvent {
  final String name;
  final String nameCreate;

  RolCreate({
    required this.name,
    required this.nameCreate,
  });
}

class RolDelete extends RolRolEvent {
  final int id;

  RolDelete({
    required this.id,
  });
}

