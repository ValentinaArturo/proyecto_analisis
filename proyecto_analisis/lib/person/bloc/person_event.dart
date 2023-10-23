part of 'person_bloc.dart';

abstract class PersonEvent {}

class Person extends PersonEvent {}

class PersonEdit extends PersonEvent {
  final String nombre;
  final String id;
  final String apellido;
  final String fechaNacimiento;
  final String idGenero;
  final String usuarioModificacion;
  final String direccion;
  final String telefono;
  final String correoElectronico;
  final String idEstadoCivil;
  PersonEdit({
    required this.nombre,
    required this.id,
    required this.usuarioModificacion,
    required this.direccion,
    required this.telefono,
    required this.correoElectronico,
    required this.idEstadoCivil,
    required this.apellido,
    required this.fechaNacimiento,
    required this.idGenero,
  });
}

class PersonCreate extends PersonEvent {
  final String nombre;
  final String direccion;
  final String usuarioCreacion;
  final String idGenero;
  final String telefono;
  final String correoElectronico;
  final String idEstadoCivil;
  final String apellido;
  final String fechaNacimiento;
  PersonCreate({
    required this.nombre,
    required this.direccion,
    required this.usuarioCreacion,
    required this.idGenero,
    required this.telefono,
    required this.correoElectronico,
    required this.idEstadoCivil,
    required this.apellido,
    required this.fechaNacimiento,
  });
}

class PersonDelete extends PersonEvent {
  final String id;

  PersonDelete({
    required this.id,
  });
}
