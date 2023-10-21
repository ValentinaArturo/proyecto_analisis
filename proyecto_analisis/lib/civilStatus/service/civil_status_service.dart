import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class CivilStatusService {
  Dio client;

  CivilStatusService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  CivilStatusService.withClient(
    this.client,
  );

  Future<Response<dynamic>> getCivilStatus() async {
    return client.get(
      civilStatusPath,
    );
  }

  Future<Response<dynamic>> civilStatusCreate({
    required final String nombre,
    required final String idUsuarioCreacion,
  }) async {
    return client.post(
      civilStatusPath,
      data: {
        "Nombre": nombre,
        "IdUsuarioCreacion": idUsuarioCreacion,
      },
    );
  }

  Future<Response<dynamic>> civilStatusEdit({
    required final String nombre,
    required final String idUsuarioModificacion,
    required final String idEstadoCivil,
  }) async {
    return client.put(
      civilStatusPath,
      data: {
        "Nombre": nombre,
        "IdUsuarioModificacion": idUsuarioModificacion,
        "IdEstadoCivil": idEstadoCivil,
      },
    );
  }

  Future<Response<dynamic>> civilStatusDelete({
    required final String idEstadoCivil,
  }) async {
    return client.delete(
      civilStatusPath,
      data: {
        "IdEstadoCivil": idEstadoCivil,
      },
    );
  }
}
