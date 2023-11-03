import 'package:dio/dio.dart';
import 'package:proyecto_analisis/factory/client_auth_factory.dart';
import 'package:proyecto_analisis/resources/api_uri.dart';

class BankAccountService {
  Dio client;

  BankAccountService()
      : client = ClientAuthFactory.buildClient(
          baseUrl,
        );

  BankAccountService.withClient(
    this.client,
  );

  Future<Response<dynamic>> getBank() async {
    return client.get(
      bankPath,
    );
  }

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
  Future<Response<dynamic>> getBankAccount() async {
    return client.get(
      bankAccountPath,
    );
  }

  Future<Response<dynamic>> bankAccountCreate({
    required final int idEmpleado,
    required final int idBanco,
    required final String numeroDeCuenta,
    required final String activa,
    required final String usuarioCreacion,
  }) async {
    return client.post(
      bankAccountPath,
      data: {
        "idEmpleado": idEmpleado,
        "idBanco": idBanco,
        "numeroDeCuenta": numeroDeCuenta,
        "activa": activa,
        "usuarioCreacion": usuarioCreacion,
      },
    );
  }

  Future<Response<dynamic>> bankAccountEdit({
    required final int idEmpleado,
    required final int idBanco,
    required final String numeroDeCuenta,
    required final String activa,
    required final String usuarioCreacion,
    required final int idCuentaBancaria,
  }) async {
    return client.put(
      bankAccountPath,
      data: {
        "idEmpleado": idEmpleado,
        "idBanco": idBanco,
        "numeroDeCuenta": numeroDeCuenta,
        "activa": activa,
        "usuarioModificacion": usuarioCreacion,
        "idCuentaBancaria": idCuentaBancaria,
      },
    );
  }

  Future<Response<dynamic>> bankAccountDelete({
    required final String idBankAccount,
  }) async {
    return client.delete(
      bankAccountPath,
      data: {
        "idCuentaBancaria": idBankAccount,
      },
    );
  }
}
