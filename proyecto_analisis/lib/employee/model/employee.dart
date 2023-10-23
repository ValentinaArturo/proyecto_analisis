class EmployeeResponse {
  final List<Employee> employees;

  EmployeeResponse({
    required this.employees,
  });

  factory EmployeeResponse.fromJson(List<dynamic> json) => EmployeeResponse(
    employees: List.from(
      (json).map(
            (employee) => Employee.fromJson(
          employee,
        ),
      ),
    ),
  );
}

class Employee {
  final String idEmpleado;
  final String idPersona;
  final String idSucursal;
  final String fechaContratacion;
  final String idPuesto;
  final String idStatusEmpleado;
  final String ingresoSueldoBase;
  final String ingresoBonificacionDecreto;
  final String ingresoOtrosIngresos;
  final String descuentoIgss;
  final String descuentoIsr;
  final String descuentoInasistencias;
  final String fechaCreacion;
  final String usuarioCreacion;
  final String? fechaModificacion;
  final String? usuarioModificacion;

  Employee({
    required this.idEmpleado,
    required this.idPersona,
    required this.idSucursal,
    required this.fechaContratacion,
    required this.idPuesto,
    required this.idStatusEmpleado,
    required this.ingresoSueldoBase,
    required this.ingresoBonificacionDecreto,
    required this.ingresoOtrosIngresos,
    required this.descuentoIgss,
    required this.descuentoIsr,
    required this.descuentoInasistencias,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    this.fechaModificacion,
    this.usuarioModificacion,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      idEmpleado: json['IdEmpleado'],
      idPersona: json['IdPersona'],
      idSucursal: json['IdSucursal'],
      fechaContratacion: json['FechaContratacion'],
      idPuesto: json['IdPuesto'],
      idStatusEmpleado: json['IdStatusEmpleado'],
      ingresoSueldoBase: json['IngresoSueldoBase'],
      ingresoBonificacionDecreto: json['IngresoBonificacionDecreto'],
      ingresoOtrosIngresos: json['IngresoOtrosIngresos'],
      descuentoIgss: json['DescuentoIgss'],
      descuentoIsr: json['DescuentoIsr'],
      descuentoInasistencias: json['DescuentoInasistencias'],
      fechaCreacion: json['FechaCreacion'],
      usuarioCreacion: json['UsuarioCreacion'],
      fechaModificacion: json['FechaModificacion'],
      usuarioModificacion: json['UsuarioModificacion'],
    );
  }
}
