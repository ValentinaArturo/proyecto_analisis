abstract class CompanyEvent {}

class Company extends CompanyEvent {}

class CompanyEdit extends CompanyEvent {
  final String name;
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
  final int passwordCantidadMayusculas;
  final int passwordCantidadMinusculas;
  final int passwordCantidadCaracteresEspeciales;
  final int passwordCantidadCaducidadDias;
  final int passwordLargo;
  final int passwordIntentosAntesDeBloquear;
  final int passwordCantidadNumeros;
  final int passwordCantidadPreguntasValidar;

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
  final int id;

  CompanyDelete({
    required this.id,
  });
}
