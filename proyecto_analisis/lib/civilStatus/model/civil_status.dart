class CivilStatusResponse {
  final List<CivilStatus> civilStatusList;

  CivilStatusResponse({
    required this.civilStatusList,
  });

  factory CivilStatusResponse.fromJson(List<dynamic> json) {
    return CivilStatusResponse(
      civilStatusList: List<CivilStatus>.from(
        json.map((status) => CivilStatus.fromJson(status)),
      ),
    );
  }
}

class CivilStatus {
  final String idEstadoCivil;
  final String nombre;
  final DateTime fechaCreacion;
  final String usuarioCreacion;
  final dynamic fechaModificacion;
  final dynamic usuarioModificacion;

  CivilStatus({
    required this.idEstadoCivil,
    required this.nombre,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
  });

  factory CivilStatus.fromJson(Map<String, dynamic> json) {
    return CivilStatus(
      idEstadoCivil: json['IdEstadoCivil'],
      nombre: json['Nombre'],
      fechaCreacion: DateTime.parse(json['FechaCreacion']),
      usuarioCreacion: json['UsuarioCreacion'],
      fechaModificacion: json['FechaModificacion'],
      usuarioModificacion: json['UsuarioModificacion'],
    );
  }
}
