import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class DepartmentService {
  Dio client;

  DepartmentService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  DepartmentService.withClient(
    this.client,
  );
  Future<Response<dynamic>> company() async {
    return client.get(
      companyPath,
    );
  }
  Future<Response<dynamic>> department() async {
    return client.get(
      departmentPath,
    );
  }

  Future<Response<dynamic>> createDepartment({
    required final String nombre,
    required final String usuarioModificacion,
    required final int idEmpresa,
  }) async {
    return client.post(
      departmentPath,
      data: {
        "Nombre": nombre,
        "IdEmpresa": idEmpresa,
        "UsuarioCreacion": usuarioModificacion,
      },
    );
  }

  Future<Response<dynamic>> editDepartment({
    required final String nombre,
    required final String usuarioModificacion,
    required final int idEmpresa,
    required final int idDepartamento,
  }) async {
    return client.put(
      departmentPath,
      data: {
        "Nombre": nombre,
        "IdEmpresa": idEmpresa,
        "UsuarioModificacion": usuarioModificacion,
        "IdDepartamento": idDepartamento,
      },
    );
  }

  Future<Response<dynamic>> departmentDelete({
    required final id,
  }) async {
    return client.delete(
      departmentPath,
      data: {
        "IdDepartamento": id,
      },
    );
  }
}
