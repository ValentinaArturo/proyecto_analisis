part of 'status_bloc.dart';

abstract class StatusEvent {}

class Status extends StatusEvent {}

class StatusEdit extends StatusEvent {
  final String nombre;
  final String idStatusUsuario;
  final String usuarioModificacion;

  StatusEdit({
    required this.nombre,
    required this.idStatusUsuario,
    required this.usuarioModificacion,
  });
}

class StatusCreate extends StatusEvent {
  final String nombre;
  final String usuarioModificacion;

  StatusCreate({
    required this.nombre,
    required this.usuarioModificacion,
  });
}

class StatusDelete extends StatusEvent {
  final String id;

  StatusDelete({
    required this.id,
  });
}
