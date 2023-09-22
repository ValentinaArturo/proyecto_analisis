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
    required String id1,
    required String id2,
    required String id3,
    required String q1,
    required String q2,
    required String q3,
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
        'preguntas': [
          {
            'pregunta': id1,
            'respuesta': q1,
          },
          {
            'pregunta': id2,
            'respuesta': q2,
          },
          {
            'pregunta': id3,
            'respuesta': q3,
          },
        ],
      },
    );
  }

  Future<Response<dynamic>> genre() async {
    return client.get(
      genrePath,
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


