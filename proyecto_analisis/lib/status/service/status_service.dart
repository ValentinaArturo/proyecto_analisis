import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class StatusService {
  Dio client;

  StatusService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  StatusService.withClient(
    this.client,
  );

  Future<Response<dynamic>> status() async {
    return client.get(
      statusPath,
    );
  }

  Future<Response<dynamic>> createStatus({
    required final String nombre,
    required final String usuarioModificacion,
  }) async {
    return client.post(
      statusPath,
      data: {
        "IdUsuarioCreacion": usuarioModificacion,
        "NombreStatus": nombre,
      },
    );
  }

  Future<Response<dynamic>> editStatus({
    required final String nombre,
    required final String usuarioModificacion,
    required final String idStatusUsuario,
  }) async {
    return client.put(statusPath, data: {
      "NombreStatus": nombre,
      "IdUsuarioModificacion": usuarioModificacion,
      "IdStatusUsuario": idStatusUsuario,
    });
  }

  Future<Response<dynamic>> statusDelete({
    required final id,
  }) async {
    return client.delete(
      statusPath,
      data: {
        "IdStatusUsuario": id,
      },
    );
  }
}
