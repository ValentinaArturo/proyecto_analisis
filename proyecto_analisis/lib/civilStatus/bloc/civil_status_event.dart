part of 'civil_status_bloc.dart';

abstract class CivilStatusEvent {}

class GetCivilStatus extends CivilStatusEvent {}

class EditCivilStatus extends CivilStatusEvent {
  final String idCivilStatus;
  final String nombre;
  final String idUsuarioModificacion;

  EditCivilStatus({
    required this.idCivilStatus,
    required this.nombre,
    required this.idUsuarioModificacion,
  });
}

class CreateCivilStatus extends CivilStatusEvent {
  final String nombre;
  final String idUsuarioCreacion;

  CreateCivilStatus({
    required this.nombre,
    required this.idUsuarioCreacion,
  });
}

class DeleteCivilStatus extends CivilStatusEvent {
  final String idCivilStatus;

  DeleteCivilStatus({
    required this.idCivilStatus,
  });
}
