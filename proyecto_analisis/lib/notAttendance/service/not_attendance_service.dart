import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class NotAttendanceService {
  Dio client;

  NotAttendanceService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  NotAttendanceService.withClient(
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
  Future<Response<dynamic>> getNotAttendance() async {
    return client.get(
      notAttendancePath,
    );
  }

  Future<Response<dynamic>> notAttendanceCreate({
    required final int idEmpleado,
    required final String fechaInicial,
    required final String fechaFinal,
    required final String motivoInasistencia,
    required final String fechaProcesado,
  }) async {
    return client.post(
      notAttendancePath,
      data: {
        "IdEmpleado": idEmpleado,
        "FechaInicial": fechaInicial,
        "FechaFinal": fechaFinal,
        "MotivoInasistencia": motivoInasistencia,
        "FechaProcesado": fechaProcesado,
      },
    );
  }

  Future<Response<dynamic>> notAttendanceEdit({
    required final int idEmpleado,
    required final String fechaInicial,
    required final String fechaFinal,
    required final String motivoInasistencia,
    required final String fechaProcesado,
    required final int idInasistencia,
  }) async {
    return client.put(
      notAttendancePath,
      data: {
        "IdEmpleado": idEmpleado,
        "FechaInicial": fechaInicial,
        "FechaFinal": fechaFinal,
        "MotivoInasistencia": motivoInasistencia,
        "FechaProcesado": fechaProcesado,
        "IdInasistencia": idInasistencia,
      },
    );
  }

  Future<Response<dynamic>> notAttendanceDelete({
    required final String idNotAttendance,
  }) async {
    return client.delete(
      notAttendancePath,
      data: {
        "idInasistencia": idNotAttendance,
      },
    );
  }
}
