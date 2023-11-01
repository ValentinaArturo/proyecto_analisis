import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class BankService {
  Dio client;

  BankService()
      : client = ClientAuthFactory.buildClient(
    baseUrl,
  );

  BankService.withClient(
      this.client,
      );

  Future<Response<dynamic>> getBank() async {
    return client.get(
      bankPath,
    );
  }



  Future<Response<dynamic>> bankCreate({
    required final String nombre,
    required final String idUsuarioCreacion,

  }) async {
    return client.post(
      bankPath,
      data: {
        "nombre": nombre,
        "usuarioCreacion": idUsuarioCreacion,

      },
    );
  }

  Future<Response<dynamic>> bankEdit({
    required final String nombre,
    required final String idUsuarioModificacion,
    required final int idBank,

  }) async {
    return client.put(
      bankPath,
      data: {
        "nombre": nombre,
        "usuarioModificacion": idUsuarioModificacion,
        "idBanco": idBank,

      },
    );
  }

  Future<Response<dynamic>> bankDelete({
    required final String idBank,
  }) async {
    return client.delete(
      bankPath,
      data: {
        "idBanco": idBank,
      },
    );
  }
}
