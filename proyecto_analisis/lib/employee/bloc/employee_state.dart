part of 'employee_bloc.dart';

abstract class EmployeeState extends BaseState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeInProgress extends EmployeeState {}

class EmployeeSuccess extends EmployeeState {
  final EmployeeResponse employeeResponse;

  EmployeeSuccess({
    required this.employeeResponse,
  });
}

class EmployeeEditSuccess extends EmployeeState {}

class EmployeeCreateSuccess extends EmployeeState {}

class EmployeeDeleteSuccess extends EmployeeState {}

class EmployeeError extends EmployeeState {
  final String? error;

  EmployeeError(
      this.error,
      );
}
