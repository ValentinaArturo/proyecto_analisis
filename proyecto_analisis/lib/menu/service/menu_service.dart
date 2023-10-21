import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class MenuService {
  Dio client;

  MenuService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  MenuService.withClient(
    this.client,
  );

  Future<Response<dynamic>> menu() async {
    return client.get(
      menuPath,
    );
  }

  Future<Response<dynamic>> menuCreate({
    required final name,
    required final menuOrder,
    required final userCreate,
    required final id,
  }) async {
    return client.post(
      menuPath,
      data: {
        "idModulo": id,
        "nombre": name,
        "ordenMenu": menuOrder,
        "usuarioCreacion": userCreate,
      },
    );
  }

  Future<Response<dynamic>> menuEdit({
    required final name,
    required final menuOrder,
    required final userCreate,
    required final id,
    required final idMenu,
  }) async {
    return client.put(
      menuPath,
      data: {
        "idMenu": idMenu,
        "idModulo": id,
        "nombre": name,
        "ordenMenu": menuOrder,
        "usuarioModificacion": userCreate,
      },
    );
  }

  Future<Response<dynamic>> menuDelete({
    required final id,
  }) async {
    return client.delete(
      menuPath,
      data: {
        "idMenu": id,
      },
    );
  }
}
