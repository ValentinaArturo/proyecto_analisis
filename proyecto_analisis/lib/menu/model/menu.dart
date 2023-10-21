class MenuResponse {
  final List<Menu> users;

  MenuResponse({
    required this.users,
  });

  factory MenuResponse.fromJson(List<dynamic> json) => MenuResponse(
      users: List.from(
        (json).map(
              (user) => Menu.fromJson(
            user,
          ),
        ),
      ));
}


class Menu {
  final String idMenu;
  final String idModulo;
  final String nombre;
  final String ordenMenu;
  final DateTime fechaCreacion;
  final String usuarioCreacion;
  final dynamic fechaModificacion;
  final dynamic usuarioModificacion;

  Menu({
    required this.idMenu,
    required this.idModulo,
    required this.nombre,
    required this.ordenMenu,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    idMenu: json["IdMenu"],
    idModulo: json["IdModulo"],
    nombre: json["Nombre"],
    ordenMenu: json["OrdenMenu"],
    fechaCreacion: DateTime.parse(json["FechaCreacion"]),
    usuarioCreacion: json["UsuarioCreacion"],
    fechaModificacion: json["FechaModificacion"],
    usuarioModificacion: json["UsuarioModificacion"],
  );

  Map<String, dynamic> toJson() => {
    "IdMenu": idMenu,
    "IdModulo": idModulo,
    "Nombre": nombre,
    "OrdenMenu": ordenMenu,
    "FechaCreacion": fechaCreacion.toIso8601String(),
    "UsuarioCreacion": usuarioCreacion,
    "FechaModificacion": fechaModificacion,
    "UsuarioModificacion": usuarioModificacion,
  };
}
