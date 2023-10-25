class StatusUserResponse {
  final List<StatusUser> statusUserList;

  StatusUserResponse({
    required this.statusUserList,
  });

  factory StatusUserResponse.fromJson(List<dynamic> json) {
    return StatusUserResponse(
      statusUserList: List<StatusUser>.from(
        json.map((status) => StatusUser.fromJson(status)),
      ),
    );
  }
}

class StatusUser {
  final String idStatusUsuario;
  final String nombre;
  final DateTime fechaCreacion;
  final String usuarioCreacion;
  final dynamic fechaModificacion;
  final dynamic usuarioModificacion;

  StatusUser({
    required this.idStatusUsuario,
    required this.nombre,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
  });

  factory StatusUser.fromJson(Map<String, dynamic> json) => StatusUser(
        idStatusUsuario: json["IdStatusUsuario"],
        nombre: json["Nombre"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        usuarioCreacion: json["UsuarioCreacion"],
        fechaModificacion: json["FechaModificacion"],
        usuarioModificacion: json["UsuarioModificacion"],
      );

  Map<String, dynamic> toJson() => {
        "IdStatusUsuario": idStatusUsuario,
        "Nombre": nombre,
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "UsuarioCreacion": usuarioCreacion,
        "FechaModificacion": fechaModificacion,
        "UsuarioModificacion": usuarioModificacion,
      };
}
