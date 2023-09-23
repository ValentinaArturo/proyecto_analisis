import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class RolService {
  Dio client;

  RolService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  RolService.withClient(
    this.client,
  );

  Future<Response<dynamic>> rol({
    required String email,
  }) async {
    return client.post(
      rolPath,
      data: {
        'usr': email,
      },
    );
  }

  Future<Response<dynamic>> options({
    required String name,
    required int rol,
  }) async {
    return client.post(
      optionPath,
      data: {
        'usr': name,
        'rol': rol,
      },
    );
  }
}
