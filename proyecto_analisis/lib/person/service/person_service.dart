import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class PersonService {
  Dio client;

  PersonService()
      : client = ClientAuthFactory.buildClient(
    baseUrl,
  );

  PersonService.withClient(
      this.client,
      );

  Future<Response<dynamic>> person() async {
    return client.get(
      personPath,
    );
  }
  Future<Response<dynamic>> genres() async {
    return client.get(
      genresPath,
    );
  }
  Future<Response<dynamic>> getCivilStatus() async {
    return client.get(
      civilStatusPath,
    );
  }
  Future<Response<dynamic>> createPerson({
    required final String nombre,
    required final String apellido,
    required final String fechaNacimiento,
    required final String idGenero,
    required final String direccion,
    required final String telefono,
    required final String correoElectronico,
    required final String idEstadoCivil,
    required final String usuarioCreacion,
  }) async {
    return client.post(
      personPath,
      data: {
        "Nombre": nombre,
        "Apellido": apellido,
        "FechaNacimiento": fechaNacimiento,
        "IdGenero": idGenero,
        "Direccion": direccion,
        "Telefono": telefono,
        "CorreoElectronico": correoElectronico,
        "IdEstadoCivil": idEstadoCivil,
        "UsuarioCreacion": usuarioCreacion,
      },
    );
  }

  Future<Response<dynamic>> editPerson({
    required final String nombre,
    required final String apellido,
    required final String fechaNacimiento,
    required final String idGenero,
    required final String direccion,
    required final String telefono,
    required final String correoElectronico,
    required final String idEstadoCivil,
    required final String usuarioModificacion,
    required final String idPersona,
  }) async {
    return client.put(
      personPath,
      data: {
        "Nombre": nombre,
        "Apellido": apellido,
        "FechaNacimiento": fechaNacimiento,
        "IdGenero": idGenero,
        "Direccion": direccion,
        "Telefono": telefono,
        "CorreoElectronico": correoElectronico,
        "IdEstadoCivil": idEstadoCivil,
        "UsuarioModificacion": usuarioModificacion,
        "IdPersona": idPersona,
      },
    );
  }

  Future<Response<dynamic>> personDelete({
    required final id,
  }) async {
    return client.delete(
      personPath,
      data: {
        "IdPersona": id,
      },
    );
  }
}
