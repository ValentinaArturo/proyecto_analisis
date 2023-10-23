part of 'employee_bloc.dart';

abstract class EmployeeEvent {}

class Employee extends EmployeeEvent {}

class EmployeeEdit extends EmployeeEvent {
  final String idPersona;
  final String idSucursal;
  final String fechaContratacion;
  final String idPuesto;
  final String idStatusEmpleado;
  final String ingresoSueldoBase;
  final String ingresoBonificacionDecreto;
  final String ingresoOtrosIngresos;
  final String descuentoIgss;
  final String decuentoISR;
  final String descuentoInasistencias;
  final String usuarioCreacion;
  final String idEmpleado;

  EmployeeEdit({
    required this.idPersona,
    required this.idSucursal,
    required this.fechaContratacion,
    required this.idPuesto,
    required this.idStatusEmpleado,
    required this.ingresoSueldoBase,
    required this.ingresoBonificacionDecreto,
    required this.ingresoOtrosIngresos,
    required this.descuentoIgss,
    required this.decuentoISR,
    required this.descuentoInasistencias,
    required this.usuarioCreacion,
    required this.idEmpleado,
  });
}

class EmployeeCreate extends EmployeeEvent {
  final String idPersona;
  final String idSucursal;
  final String fechaContratacion;
  final String idPuesto;
  final String idStatusEmpleado;
  final String ingresoSueldoBase;
  final String ingresoBonificacionDecreto;
  final String ingresoOtrosIngresos;
  final String descuentoIgss;
  final String decuentoISR;
  final String descuentoInasistencias;
  final String usuarioCreacion;

  EmployeeCreate({
    required this.idPersona,
    required this.idSucursal,
    required this.fechaContratacion,
    required this.idPuesto,
    required this.idStatusEmpleado,
    required this.ingresoSueldoBase,
    required this.ingresoBonificacionDecreto,
    required this.ingresoOtrosIngresos,
    required this.descuentoIgss,
    required this.decuentoISR,
    required this.descuentoInasistencias,
    required this.usuarioCreacion,
  });
}

class EmployeeDelete extends EmployeeEvent {
  final String id;

  EmployeeDelete({
    required this.id,
  });
}
