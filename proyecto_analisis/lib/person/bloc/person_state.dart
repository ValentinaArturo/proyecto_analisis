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

class GenresSuccess extends PersonState {
  final GenresResponse genresResponse;

  GenresSuccess({
    required this.genresResponse,
  });
}

class CivilStatusSuccess extends PersonState {
  final CivilStatusResponse success;

  CivilStatusSuccess({
    required this.success,
  });
}
