import 'package:equatable/equatable.dart';

class PolicyResponse extends Equatable {
  final List<Policy> policies;

  const PolicyResponse({
    required this.policies,
  });

  factory PolicyResponse.fromJson(
    List<dynamic> json,
  ) {
    return PolicyResponse(
      policies: List.from(
        (json).map(
          (policy) => Policy.fromJson(
            policy,
          ),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [];
}

class Policy {
  final String passwordCantidadMayusculas;
  final String passwordCantidadMinusculas;
  final String passwordCantidadCaracteresEspeciales;
  final String passwordLargo;
  final String passwordCantidadNumeros;

  Policy({
    required this.passwordCantidadMayusculas,
    required this.passwordCantidadMinusculas,
    required this.passwordCantidadCaracteresEspeciales,
    required this.passwordLargo,
    required this.passwordCantidadNumeros,
  });

  factory Policy.fromJson(Map<String, dynamic> json) => Policy(
        passwordCantidadMayusculas: json["PasswordCantidadMayusculas"],
        passwordCantidadMinusculas: json["PasswordCantidadMinusculas"],
        passwordCantidadCaracteresEspeciales:
            json["PasswordCantidadCaracteresEspeciales"],
        passwordLargo: json["PasswordLargo"],
        passwordCantidadNumeros: json["PasswordCantidadNumeros"],
      );

  Map<String, dynamic> toJson() => {
        "PasswordCantidadMayusculas": passwordCantidadMayusculas,
        "PasswordCantidadMinusculas": passwordCantidadMinusculas,
        "PasswordCantidadCaracteresEspeciales":
            passwordCantidadCaracteresEspeciales,
        "PasswordLargo": passwordLargo,
        "PasswordCantidadNumeros": passwordCantidadNumeros,
      };
}
