import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class ModulesService {
  Dio client;

  ModulesService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  ModulesService.withClient(
    this.client,
  );

  Future<Response<dynamic>> modules() async {
    return client.get(
      modulesPath,
    );
  }

  Future<Response<dynamic>> modulesCreate({
    required final name,
    required final menuOrder,
    required final userCreate,
  }) async {
    return client.post(
      modulesPath,
      data: {
        "nombre": name,
        "ordenMenu": menuOrder,
        "usuarioCreacion": userCreate,
      },
    );
  }

  Future<Response<dynamic>> modulesEdit({
    required final name,
    required final menuOrder,
    required final userCreate,
    required final id,
  }) async {
    return client.put(
      modulesPath,
      data: {
        "nombre": name,
        "ordenMenu": menuOrder,
        "usuarioCreacion": userCreate,
        "idModulo": id,
      },
    );
  }

  Future<Response<dynamic>> modulesDelete({
    required final id,
  }) async {
    return client.delete(
      modulesPath,
      data: {
        "idModulo": id,
      },
    );
  }
}
