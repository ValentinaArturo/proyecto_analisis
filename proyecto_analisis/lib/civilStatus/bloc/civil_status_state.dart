part of 'civil_status_bloc.dart';

abstract class CivilStatusState extends BaseState {}

class CivilStatusInitial extends CivilStatusState {}

class CivilStatusInProgress extends CivilStatusState {}

class CivilStatusSuccess extends CivilStatusState {
  final CivilStatusResponse success;

  CivilStatusSuccess({
    required this.success,
  });
}

class CivilStatusEditSuccess extends CivilStatusState {}

class CivilStatusCreateSuccess extends CivilStatusState {}

class CivilStatusDeleteSuccess extends CivilStatusState {}

class CivilStatusError extends CivilStatusState {
  final String? error;

  CivilStatusError(this.error);
}
