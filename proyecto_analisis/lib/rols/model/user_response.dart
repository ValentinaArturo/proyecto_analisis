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
  DateTime ultimaFechaIngreso;
  String intentosDeAcceso;
  dynamic sesionActual;
  dynamic ultimaFechaCambioPassword;
  String correoElectronico;
  String requiereCambiarPassword;
  dynamic fotografia;
  String telefonoMovil;
  String idSucursal;
  DateTime fechaCreacion;
  String usuarioCreacion;
  dynamic fechaModificacion;
  dynamic usuarioModificacion;
  String jwt;

  User({
    required this.idUsuario,
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    required this.idStatusUsuario,
    required this.password,
    required this.idGenero,
    required this.ultimaFechaIngreso,
    required this.intentosDeAcceso,
    required this.sesionActual,
    required this.ultimaFechaCambioPassword,
    required this.correoElectronico,
    required this.requiereCambiarPassword,
    required this.fotografia,
    required this.telefonoMovil,
    required this.idSucursal,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
    required this.jwt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        idUsuario: json["IdUsuario"],
        nombre: json["Nombre"],
        apellido: json["Apellido"],
        fechaNacimiento: DateTime.parse(json["FechaNacimiento"]),
        idStatusUsuario: json["IdStatusUsuario"],
        password: json["Password"],
        idGenero: json["IdGenero"],
        ultimaFechaIngreso: DateTime.parse(json["UltimaFechaIngreso"]),
        intentosDeAcceso: json["IntentosDeAcceso"],
        sesionActual: json["SesionActual"],
        ultimaFechaCambioPassword: json["UltimaFechaCambioPassword"],
        correoElectronico: json["CorreoElectronico"],
        requiereCambiarPassword: json["RequiereCambiarPassword"],
        fotografia: json["Fotografia"],
        telefonoMovil: json["TelefonoMovil"],
        idSucursal: json["IdSucursal"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        usuarioCreacion: json["UsuarioCreacion"],
        fechaModificacion: json["FechaModificacion"],
        usuarioModificacion: json["UsuarioModificacion"],
        jwt: json["JWT"],
      );

  Map<String, dynamic> toJson() => {
        "IdUsuario": idUsuario,
        "Nombre": nombre,
        "Apellido": apellido,
        "FechaNacimiento":
            "${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}",
        "IdStatusUsuario": idStatusUsuario,
        "Password": password,
        "IdGenero": idGenero,
        "UltimaFechaIngreso": ultimaFechaIngreso.toIso8601String(),
        "IntentosDeAcceso": intentosDeAcceso,
        "SesionActual": sesionActual,
        "UltimaFechaCambioPassword": ultimaFechaCambioPassword,
        "CorreoElectronico": correoElectronico,
        "RequiereCambiarPassword": requiereCambiarPassword,
        "Fotografia": fotografia,
        "TelefonoMovil": telefonoMovil,
        "IdSucursal": idSucursal,
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "UsuarioCreacion": usuarioCreacion,
        "FechaModificacion": fechaModificacion,
        "UsuarioModificacion": usuarioModificacion,
        "JWT": jwt,
      };
}
