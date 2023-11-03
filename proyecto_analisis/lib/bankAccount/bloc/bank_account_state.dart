part of 'bank_account_bloc.dart';

abstract class BankAccountState extends BaseState {}

class BankAccountInitial extends BankAccountState {}

class BankAccountInProgress extends BankAccountState {}

class BankAccountSuccess extends BankAccountState {
  final BankAccountResponse success;

  BankAccountSuccess({
    required this.success,
  });
}

class BankAccountEditSuccess extends BankAccountState {
  final String msg;

  BankAccountEditSuccess(this.msg);
}

class BankAccountCreateSuccess extends BankAccountState {}

class BankAccountDeleteSuccess extends BankAccountState {}

class BankAccountError extends BankAccountState {
  final String? error;

  BankAccountError(this.error);
}

class EmployeeSuccess extends BankAccountState {
  final EmployeeResponse employeeResponse;

  EmployeeSuccess({
    required this.employeeResponse,
  });
}

class PersonSuccess extends BankAccountState {
  final PersonResponse personResponse;

  PersonSuccess({
    required this.personResponse,
  });
}
class BankSuccess extends BankAccountState {
  final BankResponse success;

  BankSuccess({
    required this.success,
  });
}
