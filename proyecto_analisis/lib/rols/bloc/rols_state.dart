import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/rols/model/user_response.dart';
import 'package:proyecto_analisis/rolsUser/model/rol.dart';
import 'package:proyecto_analisis/rolsUser/model/rol_user.dart';

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

class RolsUserSuccess extends RolsState {
  final RolUserResponse rolUserResponse;

  const RolsUserSuccess({
    required this.rolUserResponse,
  });
}

class RolsUserEditSuccess extends RolsState {}

class RolsUserCreateSuccess extends RolsState {}

class RolsUserDeleteSuccess extends RolsState {}

class RolsError extends RolsState {
  final String? error;

  const RolsError(
    this.error,
  );
}
class RolListSuccess extends RolsState {
  final RolResponse rolResponse;

  RolListSuccess(this.rolResponse);

}

