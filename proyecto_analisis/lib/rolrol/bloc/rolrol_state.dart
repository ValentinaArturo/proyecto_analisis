part of 'rolrol_bloc.dart';

@immutable
abstract class RolRolState extends BaseState{}

class RolRolInitial extends RolRolState {}

class RolRolInProgress extends RolRolState {}

class RolRolSuccess extends RolRolState {
  final RolResponse rolRolResponse;

  RolRolSuccess({
    required this.rolRolResponse,
  });
}

class RolRolEditSuccess extends RolRolState {}

class RolRolCreateSuccess extends RolRolState {}

class RolRolDeleteSuccess extends RolRolState {}

class RolRolError extends RolRolState {
  final String? error;

  RolRolError(
    this.error,
  );
}
