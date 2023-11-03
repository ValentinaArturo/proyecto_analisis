class NotAssistanceResponse {
  final List<NotAssitance> notassitances;

  NotAssistanceResponse({
    required this.notassitances,
  });

  factory NotAssistanceResponse.fromJson(List<dynamic> json) {
    return NotAssistanceResponse(
      notassitances: List<NotAssitance>.from(
        json.map((status) => NotAssitance.fromJson(status)),
      ),
    );
  }
}

class NotAssitance {
  final String idInasistencia;
  final String idEmpleado;
  final dynamic fechaInicial;
  final dynamic fechaFinal;
  final String motivoInasistencia;
  final dynamic fechaProcesado;
  final dynamic fechaCreacion;
  final String usuarioCreacion;
  final dynamic fechaModificacion;
  final dynamic usuarioModificacion;

  NotAssitance({
    required this.idInasistencia,
    required this.idEmpleado,
    required this.fechaInicial,
    required this.fechaFinal,
    required this.motivoInasistencia,
    required this.fechaProcesado,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
  });

  factory NotAssitance.fromJson(Map<String, dynamic> json) => NotAssitance(
        idInasistencia: json["IdInasistencia"],
        idEmpleado: json["IdEmpleado"],
        fechaInicial: DateTime.parse(json["FechaInicial"]),
        fechaFinal: DateTime.parse(json["FechaFinal"]),
        motivoInasistencia: json["MotivoInasistencia"],
        fechaProcesado: DateTime.parse(json["FechaProcesado"]),
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        usuarioCreacion: json["UsuarioCreacion"],
        fechaModificacion: json["FechaModificacion"],
        usuarioModificacion: json["UsuarioModificacion"],
      );
}
