import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class PositionService {
  Dio client;

  PositionService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  PositionService.withClient(
    this.client,
  );

  Future<Response<dynamic>> position() async {
    return client.get(
      positionPath,
    );
  }

  Future<Response<dynamic>> createPosition({
    required final String nombre,
    required final String idDepartamento,
    required final String usuarioModificacion,
  }) async {
    return client.post(
      positionPath,
      data: {
        "Nombre": nombre,
        "IdDepartamento": idDepartamento,
        "UsuarioCreacion": usuarioModificacion,
      },
    );
  }

  Future<Response<dynamic>> editPosition({
    required final String nombre,
    required final String idDepartamento,
    required final String usuarioModificacion,
    required final String idPuesto,
  }) async {
    return client.put(
      positionPath,
      data: {
        "Nombre": nombre,
        "IdDepartamento": idDepartamento,
        "UsuarioModificacion": usuarioModificacion,
        "IdPuesto": idPuesto,
      },
    );
  }

  Future<Response<dynamic>> positionDelete({
    required final id,
  }) async {
    return client.delete(
      positionPath,
      data: {
        "IdPuesto": id,
      },
    );
  }
}
