class ModulesResponse {
  final List<Modules> users;

  ModulesResponse({
    required this.users,
  });

  factory ModulesResponse.fromJson(List<dynamic> json) => ModulesResponse(
          users: List.from(
        (json).map(
          (user) => Modules.fromJson(
            user,
          ),
        ),
      ));
}

class Modules {
  final int idModulo;
  final String nombre;
  final int ordenMenu;

  Modules({
    required this.idModulo,
    required this.nombre,
    required this.ordenMenu,
  });

  factory Modules.fromJson(Map<String, dynamic> json) => Modules(
        idModulo: json["IdModulo"],
        nombre: json["Nombre"],
        ordenMenu: json["OrdenMenu"],
      );
}
