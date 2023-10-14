part of 'modules_bloc.dart';

@immutable
abstract class ModulesState extends BaseState{}

class ModulesInitial extends ModulesState {}

class ModulesInProgress extends ModulesState {}

class ModulesSuccess extends ModulesState {
  final ModulesResponse modulesResponse;

  ModulesSuccess({
    required this.modulesResponse,
  });
}

class ModulesEditSuccess extends ModulesState {}

class ModulesCreateSuccess extends ModulesState {}

class ModulesDeleteSuccess extends ModulesState {}

class ModulesError extends ModulesState {
  final String? error;

  ModulesError(
    this.error,
  );
}
