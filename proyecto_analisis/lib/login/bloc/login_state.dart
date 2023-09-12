import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/login/model/user_session.dart';

abstract class LoginState extends BaseState {
  const LoginState();
}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class DeviceInProgress extends LoginState {}

class LoginSuccess extends LoginState {
  final UserSession userSession;

  const LoginSuccess({
    required this.userSession,
  });
}

class DeviceIdSuccess extends LoginState {
  final String deviceId;

  const DeviceIdSuccess({
    required this.deviceId,
  });
}

class LoginError extends LoginState {
  final String? error;

  LoginError(
    this.error,
  );
}

class BiometricCheckInProgress extends LoginState {}

class FaceIdFound extends LoginState {}

class FingerprintFound extends LoginState {}
