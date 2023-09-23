import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/rol/model/menu_response.dart';
import 'package:proyecto_analisis/rol/model/rol_response.dart';

abstract class RolState extends BaseState {
  const RolState();
}

class RolInitial extends RolState {}

class RolInProgress extends RolState {}

class RolSuccess extends RolState {
  final RolResponse rolResponse;

  const RolSuccess({
    required this.rolResponse,
  });
}

class RolError extends RolState {
  final String? error;

  const RolError(
    this.error,
  );
}

class OptionSuccess extends RolState {
  final MenuResponse menuResponse;

  const OptionSuccess({
    required this.menuResponse,
  });
}
