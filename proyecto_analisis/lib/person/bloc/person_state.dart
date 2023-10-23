part of 'person_bloc.dart';


abstract class PersonState extends BaseState {}

class PersonInitial extends PersonState {}

class PersonInProgress extends PersonState {}

class PersonSuccess extends PersonState {
  final PersonResponse personResponse;

  PersonSuccess({
    required this.personResponse,
  });
}

class PersonEditSuccess extends PersonState {}

class PersonCreateSuccess extends PersonState {}

class PersonDeleteSuccess extends PersonState {}

class PersonError extends PersonState {
  final String? error;

  PersonError(
      this.error,
      );
}
