class PositionResponse {
  final List<Position> positions;

  PositionResponse({
    required this.positions,
  });

  factory PositionResponse.fromJson(List<dynamic> json) {
    return PositionResponse(
      positions: List<Position>.from(
        json.map((position) => Position.fromJson(position)),
      ),
    );
  }
}

class Position {
  final String idPuesto;
  final String nombre;
  final String idDepartamento;
  final String fechaCreacion;
  final String usuarioCreacion;
  final String? fechaModificacion;
  final String? usuarioModificacion;

  Position({
    required this.idPuesto,
    required this.nombre,
    required this.idDepartamento,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    this.fechaModificacion,
    this.usuarioModificacion,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      idPuesto: json['IdPuesto'],
      nombre: json['Nombre'],
      idDepartamento: json['IdDepartamento'],
      fechaCreacion: json['FechaCreacion'],
      usuarioCreacion: json['UsuarioCreacion'],
      fechaModificacion: json['FechaModificacion'],
      usuarioModificacion: json['UsuarioModificacion'],
    );
  }
}
