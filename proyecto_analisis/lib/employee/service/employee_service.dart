import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class EmployeeService {
  Dio client;

  EmployeeService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  EmployeeService.withClient(
    this.client,
  );

  Future<Response<dynamic>> employee() async {
    return client.get(
      employeePath,
    );
  }

  Future<Response<dynamic>> person() async {
    return client.get(
      personPath,
    );
  }

  Future<Response<dynamic>> branch() async {
    return client.get(
      branchPath,
    );
  }

  Future<Response<dynamic>> position() async {
    return client.get(
      positionPath,
    );
  }

  Future<Response<dynamic>> status() async {
    return client.get(
      statusPath,
    );
  }

  Future<Response<dynamic>> createEmployee({
    required int idPersona,
    required int idSucursal,
    required String fechaContratacion,
    required int idPuesto,
    required int idStatusEmpleado,
    required String ingresoSueldoBase,
    required String ingresoBonificacionDecreto,
    required String ingresoOtrosIngresos,
    required String usuarioCreacion,
  }) async {
    return client.post(
      employeePath,
      data: {
        "IdPersona": idPersona,
        "IdSucursal": idSucursal,
        "FechaContratacion": fechaContratacion,
        "IdPuesto": idPuesto,
        "IdStatusEmpleado": idStatusEmpleado,
        "IngresoSueldoBase": ingresoSueldoBase,
        "IngresoBonificacionDecreto": ingresoBonificacionDecreto,
        "IngresoOtrosIngresos": ingresoOtrosIngresos,
        "UsuarioCreacion": usuarioCreacion,
      },
    );
  }

  Future<Response<dynamic>> editEmployee({
    required int idPersona,
    required int idSucursal,
    required String fechaContratacion,
    required int idPuesto,
    required int idStatusEmpleado,
    required String ingresoSueldoBase,
    required String ingresoBonificacionDecreto,
    required String ingresoOtrosIngresos,
    required String usuarioCreacion,
    required int idEmpleado,
  }) async {
    return client.put(
      employeePath,
      data: {
        "IdPersona": idPersona,
        "IdSucursal": idSucursal,
        "FechaContratacion": fechaContratacion,
        "IdPuesto": idPuesto,
        "IdStatusEmpleado": idStatusEmpleado,
        "IngresoSueldoBase": ingresoSueldoBase,
        "IngresoBonificacionDecreto": ingresoBonificacionDecreto,
        "IngresoOtrosIngresos": ingresoOtrosIngresos,
        "UsuarioModificacion": usuarioCreacion,
        "IdEmpleado": idEmpleado,
      },
    );
  }

  Future<Response<dynamic>> employeeDelete({
    required final id,
  }) async {
    return client.delete(
      employeePath,
      data: {
        "IdEmpleado": id,
      },
    );
  }
}
