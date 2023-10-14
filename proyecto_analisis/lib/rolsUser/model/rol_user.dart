class RolUserResponse {
  final List<RolUser> rols;

  RolUserResponse({
    required this.rols,
  });

  factory RolUserResponse.fromJson(List<dynamic> json) => RolUserResponse(
          rols: List.from(
        (json).map(
          (user) => RolUser.fromJson(
            user,
          ),
        ),
      ));
}

class RolUser {
  final String nombreUsuario;
  final String nombreRol;

  RolUser({
    required this.nombreUsuario,
    required this.nombreRol,
  });

  factory RolUser.fromJson(Map<String, dynamic> json) => RolUser(
        nombreUsuario: json["NombreUsuario"],
        nombreRol: json["NombreRol"],
      );

  Map<String, dynamic> toJson() => {
        "NombreUsuario": nombreUsuario,
        "NombreRol": nombreRol,
      };
}
