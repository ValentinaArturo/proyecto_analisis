class StatusResponse {
  final List<Status> statusList;

  StatusResponse({
    required this.statusList,
  });

  factory StatusResponse.fromJson(List<dynamic> json) {
    return StatusResponse(
      statusList: List<Status>.from(
        json.map((status) => Status.fromJson(status)),
      ),
    );
  }
}

class Status {
  final String idStatusEmpleado;
  final String nombre;
  final String fechaCreacion;
  final String usuarioCreacion;
  final String? fechaModificacion;
  final String? usuarioModificacion;

  Status({
    required this.idStatusEmpleado,
    required this.nombre,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    this.fechaModificacion,
    this.usuarioModificacion,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      idStatusEmpleado: json['IdStatusEmpleado'],
      nombre: json['Nombre'],
      fechaCreacion: json['FechaCreacion'],
      usuarioCreacion: json['UsuarioCreacion'],
      fechaModificacion: json['FechaModificacion'],
      usuarioModificacion: json['UsuarioModificacion'],
    );
  }
}
