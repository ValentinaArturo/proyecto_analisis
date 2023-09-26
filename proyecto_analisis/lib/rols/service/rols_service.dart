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
}
