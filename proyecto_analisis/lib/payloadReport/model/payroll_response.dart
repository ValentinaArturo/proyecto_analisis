class PayrollResponse {
  final List<Cabecera> cabecera;
  final List<Detalle> detalle;

  PayrollResponse({
    required this.cabecera,
    required this.detalle,
  });

  factory PayrollResponse.fromJson(Map<String, dynamic> json) =>
      PayrollResponse(
        cabecera: List<Cabecera>.from(
            json["cabecera"].map((x) => Cabecera.fromJson(x))),
        detalle:
            List<Detalle>.from(json["detalle"].map((x) => Detalle.fromJson(x))),
      );
}

class Cabecera {
  final String anio;
  final String mes;
  final String totalIngresos;
  final String totalDescuentos;
  final String salarioNeto;
  final dynamic fechaHoraProcesada;
  final dynamic fechaCreacion;
  final String usuarioCreacion;
  final dynamic fechaModificacion;
  final dynamic usuarioModificacion;

  Cabecera({
    required this.anio,
    required this.mes,
    required this.totalIngresos,
    required this.totalDescuentos,
    required this.salarioNeto,
    required this.fechaHoraProcesada,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
  });

  factory Cabecera.fromJson(Map<String, dynamic> json) => Cabecera(
        anio: json["Anio"],
        mes: json["Mes"],
        totalIngresos: json["TotalIngresos"],
        totalDescuentos: json["TotalDescuentos"],
        salarioNeto: json["SalarioNeto"],
        fechaHoraProcesada: DateTime.parse(json["FechaHoraProcesada"]),
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        usuarioCreacion: json["UsuarioCreacion"],
        fechaModificacion: json["FechaModificacion"],
        usuarioModificacion: json["UsuarioModificacion"],
      );
}

class Detalle {
  final String idEmpleado;
  final String anio;
  final String mes;
  final String nombreEmpleado;
  final dynamic fechaContratacion;
  final String puesto;
  final String estadoUsuario;
  final String ingresoSueldoBase;
  final String ingresoBonificacionDecreto;
  final String ingresoOtrosIngresos;
  final String descuentoIgss;
  final String descuentoIsr;
  final String descuentoInasistencias;
  final String salarioNeto;

  Detalle({
    required this.idEmpleado,
    required this.anio,
    required this.mes,
    required this.nombreEmpleado,
    required this.fechaContratacion,
    required this.puesto,
    required this.estadoUsuario,
    required this.ingresoSueldoBase,
    required this.ingresoBonificacionDecreto,
    required this.ingresoOtrosIngresos,
    required this.descuentoIgss,
    required this.descuentoIsr,
    required this.descuentoInasistencias,
    required this.salarioNeto,
  });

  factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        idEmpleado: json["IdEmpleado"],
        anio: json["Anio"],
        mes: json["Mes"],
        nombreEmpleado: json["Nombre Empleado"],
        fechaContratacion: DateTime.parse(json["FechaContratacion"]),
        puesto: json["Puesto"],
        estadoUsuario: json["Estado Usuario"],
        ingresoSueldoBase: json["IngresoSueldoBase"],
        ingresoBonificacionDecreto: json["IngresoBonificacionDecreto"],
        ingresoOtrosIngresos: json["IngresoOtrosIngresos"],
        descuentoIgss: json["DescuentoIgss"],
        descuentoIsr: json["DescuentoIsr"],
        descuentoInasistencias: json["DescuentoInasistencias"],
        salarioNeto: json["SalarioNeto"],
      );
}
