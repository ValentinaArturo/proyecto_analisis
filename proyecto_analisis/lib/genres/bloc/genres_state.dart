import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/genres/model/genres.dart';



abstract class GenresState extends BaseState {}

class GenresInitial extends GenresState {}

class GenresInProgress extends GenresState {}

class GenresSuccess extends GenresState {
  final GenresResponse genresResponse;

  GenresSuccess({
    required this.genresResponse,
  });
}

class GenresEditSuccess extends GenresState {}

class GenresCreateSuccess extends GenresState {}

class GenresDeleteSuccess extends GenresState {}

class GenresError extends GenresState {
  final String? error;

  GenresError(
    this.error,
  );
}
