part of 'not_assistance_bloc.dart';

abstract class NotAssistanceState extends BaseState {}

class NotAssistanceInitial extends NotAssistanceState {}

class NotAssistanceInProgress extends NotAssistanceState {}

class NotAssistanceSuccess extends NotAssistanceState {
  final NotAssistanceResponse success;

  NotAssistanceSuccess({
    required this.success,
  });
}

class NotAssistanceEditSuccess extends NotAssistanceState {}

class NotAssistanceCreateSuccess extends NotAssistanceState {}

class NotAssistanceDeleteSuccess extends NotAssistanceState {}

class NotAssistanceError extends NotAssistanceState {
  final String? error;

  NotAssistanceError(this.error);
}

class EmployeeSuccess extends NotAssistanceState {
  final EmployeeResponse employeeResponse;

  EmployeeSuccess({
    required this.employeeResponse,
  });
}

class PersonSuccess extends NotAssistanceState {
  final PersonResponse personResponse;

  PersonSuccess({
    required this.personResponse,
  });
}
