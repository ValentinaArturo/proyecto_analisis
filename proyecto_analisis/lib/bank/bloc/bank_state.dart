part of 'bank_bloc.dart';

abstract class BankState extends BaseState {}

class BankInitial extends BankState {}

class BankInProgress extends BankState {}

class BankSuccess extends BankState {
  final BankResponse success;

  BankSuccess({
    required this.success,
  });
}

class BankEditSuccess extends BankState {}

class BankCreateSuccess extends BankState {}

class BankDeleteSuccess extends BankState {}

class BankError extends BankState {
  final String? error;

  BankError(this.error);
}

