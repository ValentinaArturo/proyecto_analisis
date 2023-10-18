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
  final String idEmpresa;
  final String nombre;
  final String direccion;
  final String nit;
  final String passwordCantidadMayusculas;
  final String passwordCantidadMinusculas;
  final String passwordCantidadCaracteresEspeciales;
  final String passwordCantidadCaducidadDias;
  final String passwordLargo;
  final String passwordIntentosAntesDeBloquear;
  final String passwordCantidadNumeros;
  final String passwordCantidadPreguntasValidar;
  final DateTime fechaCreacion;
  final String usuarioCreacion;


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
      };
}
