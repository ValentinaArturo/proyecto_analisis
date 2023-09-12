import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class LoginService {
  Dio client;

  LoginService()
      : client = ClientFactory.buildClient(
          baseUrl,
        );

  LoginService.withClient(
    this.client,
  );

  Future<Response<dynamic>> loginWithPassword({
    required String password,
    required String email,
  }) async {
    return client.post(
      loginPath,
      data: {
        'email': email,
        'password': password,
      },
    );
  }
}
