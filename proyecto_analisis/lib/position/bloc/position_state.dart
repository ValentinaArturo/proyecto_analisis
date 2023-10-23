part of 'position_bloc.dart';

abstract class PositionState extends BaseState {}

class PositionInitial extends PositionState {}

class PositionInProgress extends PositionState {}

class PositionSuccess extends PositionState {
  final PositionResponse positionResponse;

  PositionSuccess({
    required this.positionResponse,
  });
}

class PositionEditSuccess extends PositionState {}

class PositionCreateSuccess extends PositionState {}

class PositionDeleteSuccess extends PositionState {}

class PositionError extends PositionState {
  final String? error;

  PositionError(
      this.error,
      );
}
