import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/rols/model/user_response.dart';

abstract class RolsState extends BaseState {
  const RolsState();
}

class RolsInitial extends RolsState {}

class RolsInProgress extends RolsState {}

class RolsSuccess extends RolsState {
  final UserResponse userResponse;

  const RolsSuccess({
    required this.userResponse,
  });
}

class RolsError extends RolsState {
  final String? error;

  const RolsError(
    this.error,
  );
}
