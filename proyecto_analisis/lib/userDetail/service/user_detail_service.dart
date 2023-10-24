import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class UserDetailService {
  Dio client;

  UserDetailService()
      : client = ClientFactory.buildClient(
          baseUrl,
        );

  UserDetailService.withClient(
    this.client,
  );
  Future<Response<dynamic>> branch() async {
    return client.get(
      branchPath,
    );
  }
  Future<Response<dynamic>> status() async {
    return client.get(
      statusPath,
    );
  }
  Future<Response<dynamic>> userDetail({
    required String email,
    required String name,
    required String lastName,
    required int genre,
    required String birthDate,
    required String phone,
    required String idSucursal,
    required String nameCreate,
    required String idUsuario,
    required String idStatusUsuario,
  }) async {
    return client.post(
      signUpPath,
      data: {
        "nombre": name,
        "apellido": lastName,
        "fechaNacimiento": birthDate,
        "genero": genre,
        "email": email,
        "telefono": phone,
        "idSucursal": idSucursal,
        "usuarioModifica": nameCreate,
        "idUsuario": idUsuario,
        "idStatusUsuario": idStatusUsuario,
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
