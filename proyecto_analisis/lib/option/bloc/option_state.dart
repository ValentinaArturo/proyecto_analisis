part of 'option_bloc.dart';

abstract class OptionState extends BaseState {}

class OptionInitial extends OptionState {}

class OptionInProgress extends OptionState {}

class OptionSuccess extends OptionState {
  final OptionResponse success;

  OptionSuccess({
    required this.success,
  });
}

class OptionEditSuccess extends OptionState {}

class OptionCreateSuccess extends OptionState {}

class OptionDeleteSuccess extends OptionState {}

class OptionError extends OptionState {
  final String? error;

  OptionError(this.error);
}
class MenuSuccess extends OptionState {
  final MenuResponse menuResponse;

  MenuSuccess({
    required this.menuResponse,
  });
}