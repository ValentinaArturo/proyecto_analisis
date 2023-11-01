import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class OptionService {
  Dio client;

  OptionService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  OptionService.withClient(
    this.client,
  );

  Future<Response<dynamic>> getOption() async {
    return client.get(
      optionsPath,
    );
  }
  Future<Response<dynamic>> menu() async {
    return client.get(
      menuPath,
    );
  }
  Future<Response<dynamic>> optionCreate({
    required final String nombre,
    required final String idUsuarioCreacion,
    required final String pagina,
    required final int ordenMenu,
    required final int idMenu,
  }) async {
    return client.post(
      optionsPath,
      data: {
        "Nombre": nombre,
        "UsuarioCreacion": idUsuarioCreacion,
        "IdMenu": idMenu,
        "OrdenMenu": ordenMenu,
        "Pagina": pagina,
      },
    );
  }

  Future<Response<dynamic>> optionEdit({
    required final String nombre,
    required final String idUsuarioModificacion,
    required final int idMenu,
    required final int ordenMenu,
    required final String pagina,
    required final int idOption,
  }) async {
    return client.put(
      optionsPath,
      data: {
        "Nombre": nombre,
        "UsuarioModificacion": idUsuarioModificacion,
        "IdMenu": idMenu,
        "OrdenMenu": ordenMenu,
        "Pagina": pagina,
        "IdOpcion": idOption,
      },
    );
  }

  Future<Response<dynamic>> optionDelete({
    required final String idOpcion,
  }) async {
    return client.delete(
      optionsPath,
      data: {
        "IdOpcion": idOpcion,
      },
    );
  }
}
