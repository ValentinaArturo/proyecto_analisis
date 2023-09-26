import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/rol/model/menu_response.dart';
import 'package:proyecto_analisis/rol/model/rol_response.dart';

abstract class RolsState extends BaseState {
  const RolsState();
}

class RolsInitial extends RolsState {}

class RolsInProgress extends RolsState {}

class RolsSuccess extends RolsState {
  final RolResponse rolResponse;

  const RolsSuccess({
    required this.rolResponse,
  });
}

class RolsError extends RolsState {
  final String? error;

  const RolsError(
    this.error,
  );
}

class OptionSuccess extends RolsState {
  final MenuResponse menuResponse;

  const OptionSuccess({
    required this.menuResponse,
  });
}
