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

  Future<Response<dynamic>> createEmployee({
    required String idPersona,
    required String idSucursal,
    required String fechaContratacion,
    required String idPuesto,
    required String idStatusEmpleado,
    required String ingresoSueldoBase,
    required String ingresoBonificacionDecreto,
    required String ingresoOtrosIngresos,
    required String descuentoIgss,
    required String decuentoISR,
    required String descuentoInasistencias,
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
        "DescuentoIgss": descuentoIgss,
        "DecuentoISR": decuentoISR,
        "DescuentoInasistencias": descuentoInasistencias,
        "UsuarioCreacion": usuarioCreacion,
      },
    );
  }

  Future<Response<dynamic>> editEmployee({
    required String idPersona,
    required String idSucursal,
    required String fechaContratacion,
    required String idPuesto,
    required String idStatusEmpleado,
    required String ingresoSueldoBase,
    required String ingresoBonificacionDecreto,
    required String ingresoOtrosIngresos,
    required String descuentoIgss,
    required String decuentoISR,
    required String descuentoInasistencias,
    required String usuarioCreacion,
    required String idEmpleado,
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
        "DescuentoIgss": descuentoIgss,
        "DecuentoISR": decuentoISR,
        "DescuentoInasistencias": descuentoInasistencias,
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
