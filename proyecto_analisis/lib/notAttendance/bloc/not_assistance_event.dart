part of 'not_assistance_bloc.dart';

abstract class NotAssistanceEvent {}

class GetNotAssistance extends NotAssistanceEvent {}

class Employee extends NotAssistanceEvent {}
class Person extends NotAssistanceEvent {}

class EditNotAssistance extends NotAssistanceEvent {
  final int idEmpleado;
  final String fechaInicial;
  final String fechaFinal;
  final String motivoInasistencia;
  final String fechaProcesado;
  final int idInasistencia;

  EditNotAssistance({
    required this.idEmpleado,
    required this.fechaFinal,
    required this.fechaInicial,
    required this.motivoInasistencia,
    required this.fechaProcesado,
    required this.idInasistencia,
  });
}

class CreateNotAssistance extends NotAssistanceEvent {
  final int idEmpleado;
  final String fechaInicial;
  final String fechaFinal;
  final String motivoInasistencia;
  final String fechaProcesado;

  CreateNotAssistance({
    required this.idEmpleado,
    required this.fechaFinal,
    required this.fechaInicial,
    required this.motivoInasistencia,
    required this.fechaProcesado,
  });
}

class DeleteNotAssistance extends NotAssistanceEvent {
  final String idNotAssistance;

  DeleteNotAssistance({
    required this.idNotAssistance,
  });
}
