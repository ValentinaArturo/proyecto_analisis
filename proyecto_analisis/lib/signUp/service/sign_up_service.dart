import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class SignUpService {
  Dio client;

  SignUpService()
      : client = ClientFactory.buildClient(
          baseUrl,
        );

  SignUpService.withClient(
    this.client,
  );

  Future<Response<dynamic>> signUp({
    required String password,
    required String email,
    required String name,
    required String lastName,
    required int genre,
    required String birthDate,
    required String phone,
  }) async {
    return client.post(
      signUpPath,
      data: {
        "nombre": name,
        "apellido": lastName,
        "fechaNacimiento": birthDate,
        "genero": genre,
        "email": email,
        "password": password,
        "telefono": phone,
      },
    );
  }

  Future<Response<dynamic>> genre() async {
    return client.get(
      genrePath,
    );
  }
}
