part of 'position_bloc.dart';

abstract class PositionEvent {}

class Position extends PositionEvent {}

class PositionEdit extends PositionEvent {
  final String nombre;
  final String idDepartamento;
  final String idPuesto;
  final String usuarioModificacion;

  PositionEdit({
    required this.nombre,
    required this.idDepartamento,
    required this.usuarioModificacion,
    required this.idPuesto,
  });
}

class PositionCreate extends PositionEvent {
  final String nombre;
  final String idDepartamento;
  final String usuarioModificacion;

  PositionCreate({
    required this.nombre,
    required this.idDepartamento,
    required this.usuarioModificacion,
  });
}

class PositionDelete extends PositionEvent {
  final String id;

  PositionDelete({
    required this.id,
  });
}
