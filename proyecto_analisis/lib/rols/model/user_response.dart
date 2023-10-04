class UserResponse {
  final List<User> users;

  UserResponse({
    required this.users,
  });

  factory UserResponse.fromJson(List<dynamic> json) => UserResponse(
          users: List.from(
        (json).map(
          (user) => User.fromJson(
            user,
          ),
        ),
      ));
}

class User {
  String idUsuario;
  String nombre;
  String apellido;
  DateTime fechaNacimiento;
  String idStatusUsuario;
  String password;
  String idGenero;
  String intentosDeAcceso;
  String correoElectronico;
  String requiereCambiarPassword;
  String? fotografia;
  String telefonoMovil;
  String idSucursal;
  String? fechaCreacion;

  User({
    required this.idUsuario,
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    required this.idStatusUsuario,
    required this.password,
    required this.idGenero,
    required this.intentosDeAcceso,
    required this.correoElectronico,
    required this.requiereCambiarPassword,
    this.fotografia,
    required this.telefonoMovil,
    required this.idSucursal,
    required this.fechaCreacion,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        idUsuario: json["IdUsuario"],
        nombre: json["Nombre"],
        apellido: json["Apellido"],
        fechaNacimiento: DateTime.parse(json["FechaNacimiento"]),
        idStatusUsuario: json["IdStatusUsuario"],
        password: json["Password"],
        idGenero: json["IdGenero"],
        intentosDeAcceso: json["IntentosDeAcceso"],
        correoElectronico: json["CorreoElectronico"],
        requiereCambiarPassword: json["RequiereCambiarPassword"],
        fotografia: json["Fotografia"] ?? '',
        telefonoMovil: json["TelefonoMovil"],
        idSucursal: json["IdSucursal"],
        fechaCreacion: json["FechaCreacion"]?? '',
      );

}
