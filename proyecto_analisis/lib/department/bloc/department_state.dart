part of 'department_bloc.dart';

abstract class DepartmentState extends BaseState {}

class DepartmentInitial extends DepartmentState {}

class DepartmentInProgress extends DepartmentState {}

class DepartmentSuccess extends DepartmentState {
  final DepartmentResponse departmentResponse;

  DepartmentSuccess({
    required this.departmentResponse,
  });
}

class DepartmentEditSuccess extends DepartmentState {}

class DepartmentCreateSuccess extends DepartmentState {}

class DepartmentDeleteSuccess extends DepartmentState {}

class DepartmentError extends DepartmentState {
  final String? error;

  DepartmentError(this.error);
}
