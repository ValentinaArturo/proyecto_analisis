import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class GenresService {
  Dio client;

  GenresService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  GenresService.withClient(
    this.client,
  );

  Future<Response<dynamic>> genres() async {
    return client.get(
      genresPath,
    );
  }

  Future<Response<dynamic>> genresCreate({
    required final name,
    required final userCreate,
  }) async {
    return client.post(
      genresPath,
      data: {
        "nombre": name,
        "usuarioCreacion": userCreate,
      },
    );
  }

  Future<Response<dynamic>> genresEdit({
    required final name,
    required final userCreate,
    required final id,
  }) async {
    return client.put(
      genresPath,
      data: {
        "nombre": name,
        "usuarioModificacion": userCreate,
        "idGenero": id,
      },
    );
  }

  Future<Response<dynamic>> genresDelete({
    required final id,
  }) async {
    return client.delete(
      genresPath,
      data: {
        "idGenero": id,
      },
    );
  }
}
