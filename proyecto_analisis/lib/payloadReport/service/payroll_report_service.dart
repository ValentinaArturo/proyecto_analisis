import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class PayrollReportService {
  Dio client;

  PayrollReportService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  PayrollReportService.withClient(
    this.client,
  );

  Future<Response<dynamic>> payrollReport({
    required final int year,
    required final int month,
  }) async {
    return client.get(
      payrollReportPath,
      queryParameters: {
        "year": year,
        "month": month,
      },
    );
  }

  Future<Response<dynamic>> createPayrollReport({
    required final int year,
    required final int month,
  }) async {
    return client.post(
      payrollReportPath,
      data: {
        "year": year,
        "month": month,
      },
    );
  }
}
