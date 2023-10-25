part of 'status_bloc.dart';

abstract class StatusState extends BaseState {}

class StatusInitial extends StatusState {}

class StatusInProgress extends StatusState {}

class StatusSuccess extends StatusState {
  final StatusResponse statusResponse;

  StatusSuccess({
    required this.statusResponse,
  });
}

class StatusEditSuccess extends StatusState {}

class StatusCreateSuccess extends StatusState {}

class StatusDeleteSuccess extends StatusState {}

class StatusError extends StatusState {
  final String? error;

  StatusError(this.error);
}
class StatusUserSuccess extends StatusState {
  final StatusUserResponse statusResponse;

  StatusUserSuccess({
    required this.statusResponse,
  });
}
class StatusUserEditSuccess extends StatusState {}

class StatusUserCreateSuccess extends StatusState {}

class StatusUserDeleteSuccess extends StatusState {}