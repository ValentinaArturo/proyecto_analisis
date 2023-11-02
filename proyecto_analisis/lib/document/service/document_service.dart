import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class DocumentService {
  Dio client;

  DocumentService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  DocumentService.withClient(
    this.client,
  );

  Future<Response<dynamic>> getDocument() async {
    return client.get(
      documentPath,
    );
  }

  Future<Response<dynamic>> getTypeDocument() async {
    return client.get(
      typeDocumentPath,
    );
  }

  Future<Response<dynamic>> person() async {
    return client.get(
      personPath,
    );
  }

  Future<Response<dynamic>> documentCreate({
    required final String idUsuarioModificacion,
    required final int idDocument,
    required final int idPersona,
    required final String noDocument,
  }) async {
    return client.post(
      documentPath,
      data: {
        "usuarioCreacion": idUsuarioModificacion,
        "idTipoDocumento": idDocument,
        "idPersona": idPersona,
        "noDocumento": noDocument,
      },
    );
  }

  Future<Response<dynamic>> documentEdit({
    required final String idUsuarioModificacion,
    required final int idDocument,
    required final int idPersona,
    required final String noDocument,
  }) async {
    return client.put(
      documentPath,
      data: {
        "usuarioModificacion": idUsuarioModificacion,
        "idTipoDocumento": idDocument,
        "idPersona": idPersona,
        "noDocumento": noDocument,
      },
    );
  }

  Future<Response<dynamic>> documentDelete({
    required final int idDocument,
    required final int idPersona,
    required final String noDocument,
  }) async {
    return client.delete(
      documentPath,
      data: {
        "idTipoDocumento": idDocument,
        "idPersona": idPersona,
        "noDocumento": noDocument,
      },
    );
  }
}
