class CompanyResponse {
  final List<Company> comapnies;

  CompanyResponse({
    required this.comapnies,
  });

  factory CompanyResponse.fromJson(List<dynamic> json) => CompanyResponse(
          comapnies: List.from(
        (json).map(
          (user) => Company.fromJson(
            user,
          ),
        ),
      ));
}

class Company {
  final int idEmpresa;
  final String nombre;
  final String direccion;
  final String nit;
  final int passwordCantidadMayusculas;
  final int passwordCantidadMinusculas;
  final int passwordCantidadCaracteresEspeciales;
  final int passwordCantidadCaducidadDias;
  final int passwordLargo;
  final int passwordIntentosAntesDeBloquear;
  final int passwordCantidadNumeros;
  final int passwordCantidadPreguntasValidar;
  final DateTime fechaCreacion;
  final String usuarioCreacion;
  final dynamic fechaModificacion;
  final dynamic usuarioModificacion;

  Company({
    required this.idEmpresa,
    required this.nombre,
    required this.direccion,
    required this.nit,
    required this.passwordCantidadMayusculas,
    required this.passwordCantidadMinusculas,
    required this.passwordCantidadCaracteresEspeciales,
    required this.passwordCantidadCaducidadDias,
    required this.passwordLargo,
    required this.passwordIntentosAntesDeBloquear,
    required this.passwordCantidadNumeros,
    required this.passwordCantidadPreguntasValidar,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        idEmpresa: json["IdEmpresa"],
        nombre: json["Nombre"],
        direccion: json["Direccion"],
        nit: json["Nit"],
        passwordCantidadMayusculas: json["PasswordCantidadMayusculas"],
        passwordCantidadMinusculas: json["PasswordCantidadMinusculas"],
        passwordCantidadCaracteresEspeciales:
            json["PasswordCantidadCaracteresEspeciales"],
        passwordCantidadCaducidadDias: json["PasswordCantidadCaducidadDias"],
        passwordLargo: json["PasswordLargo"],
        passwordIntentosAntesDeBloquear:
            json["PasswordIntentosAntesDeBloquear"],
        passwordCantidadNumeros: json["PasswordCantidadNumeros"],
        passwordCantidadPreguntasValidar:
            json["PasswordCantidadPreguntasValidar"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        usuarioCreacion: json["UsuarioCreacion"],
        fechaModificacion: json["FechaModificacion"],
        usuarioModificacion: json["UsuarioModificacion"],
      );

  Map<String, dynamic> toJson() => {
        "IdEmpresa": idEmpresa,
        "Nombre": nombre,
        "Direccion": direccion,
        "Nit": nit,
        "PasswordCantidadMayusculas": passwordCantidadMayusculas,
        "PasswordCantidadMinusculas": passwordCantidadMinusculas,
        "PasswordCantidadCaracteresEspeciales":
            passwordCantidadCaracteresEspeciales,
        "PasswordCantidadCaducidadDias": passwordCantidadCaducidadDias,
        "PasswordLargo": passwordLargo,
        "PasswordIntentosAntesDeBloquear": passwordIntentosAntesDeBloquear,
        "PasswordCantidadNumeros": passwordCantidadNumeros,
        "PasswordCantidadPreguntasValidar": passwordCantidadPreguntasValidar,
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "UsuarioCreacion": usuarioCreacion,
        "FechaModificacion": fechaModificacion,
        "UsuarioModificacion": usuarioModificacion,
      };
}
