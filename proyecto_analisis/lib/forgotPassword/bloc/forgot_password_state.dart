import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/models/success_response.dart';

abstract class ForgotPasswordState extends BaseState {
  const ForgotPasswordState();
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordInProgress extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final SuccessResponse successResponse;

  const ForgotPasswordSuccess({
    required this.successResponse,
  });
}

class ForgotPasswordError extends ForgotPasswordState {
  final String? error;

  const ForgotPasswordError(
    this.error,
  );
}
