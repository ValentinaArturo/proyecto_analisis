class RolResponse {
  final List<Rol> rols;

  RolResponse({
    required this.rols,
  });

  factory RolResponse.fromJson(List<dynamic> json) => RolResponse(
          rols: List.from(
        (json).map(
          (user) => Rol.fromJson(
            user,
          ),
        ),
      ));
}

class Rol {
  final String idRole;
  final String nombre;
  final DateTime fechaCreacion;
  final String usuarioCreacion;
  final DateTime? fechaModificacion;
  final String? usuarioModificacion;

  Rol({
    required this.idRole,
    required this.nombre,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
  });

  factory Rol.fromJson(Map<String, dynamic> json) => Rol(
        idRole: json["IdRole"],
        nombre: json["Nombre"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        usuarioCreacion: json["UsuarioCreacion"],
        fechaModificacion: json["FechaModificacion"] == null
            ? null
            : DateTime.parse(json["FechaModificacion"]),
        usuarioModificacion: json["UsuarioModificacion"],
      );

  Map<String, dynamic> toJson() => {
        "IdRole": idRole,
        "Nombre": nombre,
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "UsuarioCreacion": usuarioCreacion,
        "FechaModificacion": fechaModificacion?.toIso8601String(),
        "UsuarioModificacion": usuarioModificacion,
      };
}
