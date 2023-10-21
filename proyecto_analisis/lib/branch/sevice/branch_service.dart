import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class BranchService {
  Dio client;

  BranchService()
      : client = ClientAuthFactory.buildClient(
    baseUrl,
  );

  BranchService.withClient(
      this.client,
      );

  Future<Response<dynamic>> branch() async {
    return client.get(
      branchPath,
    );
  }

  Future<Response<dynamic>> branchCreate({
    required final id,
    required final nombre,
    required final direccion,
    required final idEmpresa,
    required final usuarioCreacion,
  }) async {
    return client.post(
      branchPath,
      data: {
        "Nombre": nombre,
        "Direccion": direccion,
        "IdEmpresa": idEmpresa,
        "UsuarioCreacion": usuarioCreacion,
        "idModulo": id,
      },
    );
  }

  Future<Response<dynamic>> branchEdit({
    required final id,
    required final idBranch,
    required final nombre,
    required final direccion,
    required final idEmpresa,
    required final usuarioCreacion,
  }) async {
    return client.put(
      branchPath,
      data: {
        "Nombre": nombre,
        "Direccion": direccion,
        "IdEmpresa": idEmpresa,
        "UsuarioCreacion": usuarioCreacion,
        "idBranch": idBranch,
        "idModulo": id,
      },
    );
  }

  Future<Response<dynamic>> branchDelete({
    required final idBranch,
  }) async {
    return client.delete(
      branchPath,
      data: {
        "IdSucursal": idBranch,
      },
    );
  }
}
