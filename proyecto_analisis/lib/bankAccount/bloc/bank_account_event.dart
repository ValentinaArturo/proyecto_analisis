part of 'bank_account_bloc.dart';

abstract class BankAccountEvent {}

class GetBankAccount extends BankAccountEvent {}

class Employee extends BankAccountEvent {}

class Person extends BankAccountEvent {}
class GetBank extends BankAccountEvent {}

class EditBankAccount extends BankAccountEvent {
  final int idEmpleado;
  final int idBanco;
  final String numeroDeCuenta;
  final String activa;
  final String usuarioCreacion;
  final int idCuentaBancaria;

  EditBankAccount({
    required this.idEmpleado,
    required this.idBanco,
    required this.numeroDeCuenta,
    required this.activa,
    required this.usuarioCreacion,
    required this.idCuentaBancaria,
  });
}

class CreateBankAccount extends BankAccountEvent {
  final int idEmpleado;
  final int idBanco;
  final String numeroDeCuenta;
  final String activa;
  final String usuarioCreacion;

  CreateBankAccount({
    required this.idEmpleado,
    required this.idBanco,
    required this.numeroDeCuenta,
    required this.activa,
    required this.usuarioCreacion,
  });
}

class DeleteBankAccount extends BankAccountEvent {
  final String idBankAccount;

  DeleteBankAccount({
    required this.idBankAccount,
  });
}
