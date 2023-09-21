import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/models/success_response.dart';

abstract class ForgotPasswordUnlockState extends BaseState {
  const ForgotPasswordUnlockState();
}

class ForgotPasswordUnlockInitial extends ForgotPasswordUnlockState {}

class ForgotPasswordUnlockInProgress extends ForgotPasswordUnlockState {}

class ForgotPasswordUnlockSuccess extends ForgotPasswordUnlockState {
  final SuccessResponse successResponse;

  const ForgotPasswordUnlockSuccess({
    required this.successResponse,
  });
}

class ForgotPasswordUnlockError extends ForgotPasswordUnlockState {
  final String? error;

  const ForgotPasswordUnlockError(
    this.error,
  );
}
