class UserSession {
  final int status;
  final String msg;
  final String token;
  final Data data;

  UserSession({
    required this.status,
    required this.msg,
    required this.token,
    required this.data,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
        status: json['status'],
        msg: json['msg'],
        token: json['token'],
        data: Data.fromJson(
          json['data'],
        ),
      );
}

class Data {
  final String idUsuario;
  final String idStatusUsuario;
  final String nombre;
  final String apellido;
  final String nombreUsuario;
  final String requiereCambiarPassword;
  final dynamic ultimaFechaCambioPassword;
  final String passwordCantidadCaducidadDias;

  Data({
    required this.idUsuario,
    required this.idStatusUsuario,
    required this.nombre,
    required this.apellido,
    required this.nombreUsuario,
    required this.requiereCambiarPassword,
    required this.ultimaFechaCambioPassword,
    required this.passwordCantidadCaducidadDias,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idUsuario: json['IdUsuario'],
        idStatusUsuario: json['IdStatusUsuario'],
        nombre: json['Nombre'],
        apellido: json['Apellido'],
        nombreUsuario: json['NombreUsuario'],
        requiereCambiarPassword: json['RequiereCambiarPassword'],
        ultimaFechaCambioPassword: json['UltimaFechaCambioPassword'],
        passwordCantidadCaducidadDias: json['PasswordCantidadCaducidadDias'],
      );
}
