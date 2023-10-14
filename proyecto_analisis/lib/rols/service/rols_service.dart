import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class RolsService {
  Dio client;

  RolsService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  RolsService.withClient(
    this.client,
  );

  Future<Response<dynamic>> users() async {
    return client.get(
      userPath,
    );
  }

  Future<Response<dynamic>> rolsUser() async {
    return client.get(
      rolsPath,
    );
  }
  Future<Response<dynamic>> rolList() async {
    return client.get(
      rolListPath,
    );
  }

  Future<Response<dynamic>> rolsSave({
    required final String user,
    required final int id,
    required final String userCreate,
  }) async {
    return client.post(rolsPath, data: {
      "IdUsuario": user,
      "IdRole": id,
      "IdUsuarioCreacion": userCreate,
    });
  }

  Future<Response<dynamic>> rolsEdit({
    required final String user,
    required final int id,
    required final String userCreate,
  }) async {
    return client.post(rolsPath, data: {
      "IdUsuario": user,
      "IdRole": id,
      "IdUsuarioCreacion": userCreate,
    });
  }

  Future<Response<dynamic>> rolsDelete({
    required final String user,
    required final int id,
  }) async {
    return client.post(rolsPath, data: {
      "IdUsuario": user,
      "IdRole": id,
    });
  }
}
