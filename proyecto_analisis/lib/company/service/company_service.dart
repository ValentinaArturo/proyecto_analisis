import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class CompanyService {
  Dio client;

  CompanyService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  CompanyService.withClient(
    this.client,
  );

  Future<Response<dynamic>> company() async {
    return client.get(
      companyPath,
    );
  }

  Future<Response<dynamic>> companyCreate({
    required final name,
    required final userCreate,
    required final nit,
    required final passwordCantidadMayusculas,
    required final passwordCantidadMinusculas,
    required final passwordCantidadCaracteresEspeciales,
    required final passwordCantidadCaducidadDias,
    required final passwordLargo,
    required final passwordIntentosAntesDeBloquear,
    required final passwordCantidadNumeros,
    required final passwordCantidadPreguntasValidar,
    required final direccion,
  }) async {
    return client.post(
      companyPath,
      data: {
        "nombre": name,
        "direccion": direccion,
        "nit": nit,
        "passwordCantidadMayusculas": passwordCantidadMayusculas,
        "passwordCantidadMinusculas": passwordCantidadMinusculas,
        "passwordCantidadCaracteresEspeciales":
            passwordCantidadCaracteresEspeciales,
        "passwordCantidadCaducidadDias": passwordCantidadCaducidadDias,
        "passwordLargo": passwordLargo,
        "passwordIntentosAntesDeBloquear": passwordIntentosAntesDeBloquear,
        "passwordCantidadNumeros": passwordCantidadNumeros,
        "passwordCantidadPreguntasValidar": passwordCantidadPreguntasValidar,
        "usuarioCreacion": userCreate,
      },
    );
  }

  Future<Response<dynamic>> companyEdit({
    required final name,
    required final userCreate,
    required final nit,
    required final passwordCantidadMayusculas,
    required final passwordCantidadMinusculas,
    required final passwordCantidadCaracteresEspeciales,
    required final passwordCantidadCaducidadDias,
    required final passwordLargo,
    required final passwordIntentosAntesDeBloquear,
    required final passwordCantidadNumeros,
    required final passwordCantidadPreguntasValidar,
    required final direccion,
  }) async {
    return client.put(
      companyPath,
      data: {
        "nombre": name,
        "direccion": direccion,
        "nit": nit,
        "passwordCantidadMayusculas": passwordCantidadMayusculas,
        "passwordCantidadMinusculas": passwordCantidadMinusculas,
        "passwordCantidadCaracteresEspeciales":
            passwordCantidadCaracteresEspeciales,
        "passwordCantidadCaducidadDias": passwordCantidadCaducidadDias,
        "passwordLargo": passwordLargo,
        "passwordIntentosAntesDeBloquear": passwordIntentosAntesDeBloquear,
        "passwordCantidadNumeros": passwordCantidadNumeros,
        "passwordCantidadPreguntasValidar": passwordCantidadPreguntasValidar,
        "usuarioModificacion": userCreate,
      },
    );
  }

  Future<Response<dynamic>> companyDelete({
    required final id,
  }) async {
    return client.delete(
      companyPath,
      data: {
        "idEmpresa": id,
      },
    );
  }
}
