import 'package:equatable/equatable.dart';
import 'package:proyecto_analisis/signUp/model/genre.dart';

class GenreResponse extends Equatable {
  final List<GenreItem> genres;

  const GenreResponse({
    required this.genres,
  });

  factory GenreResponse.fromJson(
    List<dynamic> json,
  ) {
    return GenreResponse(
      genres: List.from(
        (json).map(
          (gen) => GenreItem.fromJson(
            gen,
          ),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [];
}
