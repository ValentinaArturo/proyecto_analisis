import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class TypeDocumentService {
  Dio client;

  TypeDocumentService()
      : client = ClientAuthFactory.buildClient(
    baseUrl,
  );

  TypeDocumentService.withClient(
      this.client,
      );

  Future<Response<dynamic>> getTypeDocument() async {
    return client.get(
      typeDocumentPath,
    );
  }

  Future<Response<dynamic>> typeDocumentCreate({
    required final String nombre,
    required final String idUsuarioCreacion,
  }) async {
    return client.post(
      typeDocumentPath,
      data: {
        "nombre": nombre,
        "usuarioCreacion": idUsuarioCreacion,
      },
    );
  }

  Future<Response<dynamic>> typeDocumentEdit({
    required final String nombre,
    required final String idUsuarioModificacion,
    required final int idTypeDocument,
  }) async {
    return client.put(
      typeDocumentPath,
      data: {
        "nombre": nombre,
        "usuarioModificacion": idUsuarioModificacion,
        "idTipoDocumento": idTypeDocument,
      },
    );
  }

  Future<Response<dynamic>> typeDocumentDelete({
    required final String idTypeDocument,
  }) async {
    return client.delete(
      typeDocumentPath,
      data: {
        "idTipoDocumento": idTypeDocument,
      },
    );
  }
}
