abstract class CompanyEvent {}

class Company extends CompanyEvent {}

class CompanyEdit extends CompanyEvent {
  final String name;
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
  final String nameCreate;

  CompanyEdit({
    required this.name,
    required this.nameCreate,
    required this.passwordCantidadNumeros,
    required this.direccion,
    required this.nit,
    required this.passwordCantidadMayusculas,
    required this.passwordCantidadMinusculas,
    required this.passwordCantidadCaracteresEspeciales,
    required this.passwordCantidadCaducidadDias,
    required this.passwordLargo,
    required this.passwordIntentosAntesDeBloquear,
    required this.passwordCantidadPreguntasValidar,
  });
}

class CompanyCreate extends CompanyEvent {
  final String name;
  final String nameCreate;
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

  CompanyCreate({
    required this.name,
    required this.nameCreate,
    required this.passwordCantidadNumeros,
    required this.direccion,
    required this.nit,
    required this.passwordCantidadMayusculas,
    required this.passwordCantidadMinusculas,
    required this.passwordCantidadCaracteresEspeciales,
    required this.passwordCantidadCaducidadDias,
    required this.passwordLargo,
    required this.passwordIntentosAntesDeBloquear,
    required this.passwordCantidadPreguntasValidar,
  });
}

class CompanyDelete extends CompanyEvent {
  final String id;

  CompanyDelete({
    required this.id,
  });
}
