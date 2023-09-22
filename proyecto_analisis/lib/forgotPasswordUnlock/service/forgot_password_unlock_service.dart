import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class ForgotPasswordUnlockService {
  Dio client;

  ForgotPasswordUnlockService()
      : client = ClientFactory.buildClient(
          baseUrl,
        );

  ForgotPasswordUnlockService.withClient(
    this.client,
  );

  Future<Response<dynamic>> forgotPasswordUnlock({
    required String newPassword,
    required String email,
    required String id1,
    required String id2,
    required String id3,
    required String q1,
    required String q2,
    required String q3,
  }) async {
    return client.post(
      recoveryPassword,
      data: {
        'email': email,
        'newPassword': newPassword,
        'respuestas': [
          {
            'IdPregunta': id1,
            'respuesta': q1,
          },
          {
            'IdPregunta': id2,
            'respuesta': q2,
          },
          {
            'IdPregunta': id3,
            'respuesta': q3,
          },
        ],
      },
    );
  }

  Future<Response<dynamic>> question({
    required final String email,
  }) async {
    return client.post(
      questionsPath,
      data: {
        'email': email,
      },
    );
  }
}
