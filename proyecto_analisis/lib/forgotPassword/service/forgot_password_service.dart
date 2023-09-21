import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class ForgotPasswordService {
  Dio client;

  ForgotPasswordService()
      : client = ClientFactory.buildClient(
          baseUrl,
        );

  ForgotPasswordService.withClient(
    this.client,
  );

  Future<Response<dynamic>> forgotPassword({
    required String newPassword,
    required String email,
    required String oldPassword,
  }) async {
    return client.post(
      recoveryPassword,
      data: {
        'email': email,
        'newPassword': newPassword,
        'oldPassword': oldPassword,
      },
    );
  }
}
