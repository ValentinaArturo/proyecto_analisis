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
class PersonSuccess extends EmployeeState {
  final PersonResponse personResponse;

  PersonSuccess({
    required this.personResponse,
  });
}

class BranchSuccess extends EmployeeState {
  final BranchResponse branchResponse;

  BranchSuccess({
    required this.branchResponse,
  });
}
class PositionSuccess extends EmployeeState {
  final PositionResponse positionResponse;

  PositionSuccess({
    required this.positionResponse,
  });
}
class StatusSuccess extends EmployeeState {
  final StatusResponse statusResponse;

  StatusSuccess({
    required this.statusResponse,
  });
}