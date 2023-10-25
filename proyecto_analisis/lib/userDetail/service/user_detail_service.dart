import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class UserDetailService {
  Dio client;

  UserDetailService()
      : client = ClientAuthFactory.buildClient(
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
      statusUserPath,
    );
  }

  Future<Response<dynamic>> userDetail({
    required String email,
    required String name,
    required String lastName,
    required String genre,
    required String birthDate,
    required String phone,
    required int idSucursal,
    required String nameCreate,
    required String idUsuario,
    required int idStatusUsuario,
  }) async {
    return client.put(
      userPath,
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
