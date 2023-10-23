part of 'department_bloc.dart';

abstract class DepartmentEvent {}

class Department extends DepartmentEvent {}

class DepartmentEdit extends DepartmentEvent {
  final String nombre;
  final String idDepartamento;
  final String usuarioModificacion;
  final String idEmpresa;

  DepartmentEdit({
    required this.nombre,
    required this.idDepartamento,
    required this.usuarioModificacion,
    required this.idEmpresa,
  });
}

class DepartmentCreate extends DepartmentEvent {
  final String nombre;
  final String usuarioModificacion;
  final String idEmpresa;

  DepartmentCreate({
    required this.nombre,
    required this.usuarioModificacion,
    required this.idEmpresa,
  });
}

class DepartmentDelete extends DepartmentEvent {
  final String id;

  DepartmentDelete({
    required this.id,
  });
}
