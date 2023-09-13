import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/login/model/user_session.dart';

abstract class LoginState extends BaseState {
  const LoginState();
}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSuccess extends LoginState {
  final UserSession userSession;

  const LoginSuccess({
    required this.userSession,
  });
}

class LoginError extends LoginState {
  final String? error;

  LoginError(
    this.error,
  );
}
