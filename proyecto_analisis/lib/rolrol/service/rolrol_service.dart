import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class RolRolService {
  Dio client;

  RolRolService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  RolRolService.withClient(
    this.client,
  );

  Future<Response<dynamic>> rolRol() async {
    return client.get(
      rolListPath,
    );
  }

  Future<Response<dynamic>> rolRolCreate({
    required final name,
    required final userCreate,
  }) async {
    return client.post(
      rolListPath,
      data: {
        "nombre": name,
        "usuarioCreacion": userCreate,
      },
    );
  }

  Future<Response<dynamic>> rolRolEdit({
    required final name,
    required final userCreate,
    required final id,
  }) async {
    return client.put(
      rolListPath,
      data: {
        "nombre": name,
        "usuarioModificacion": userCreate,
        "idRole": id,
      },
    );
  }

  Future<Response<dynamic>> rolRolDelete({
    required final id,
  }) async {
    return client.delete(
      rolListPath,
      data: {
        "idRole": id,
      },
    );
  }
}
