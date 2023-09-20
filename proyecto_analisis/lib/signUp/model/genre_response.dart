import 'package:equatable/equatable.dart';
import 'package:proyecto_analisis/signUp/model/genre.dart';

class GenreResponse extends Equatable {
  final List<Genre> genres;

  const GenreResponse({
    required this.genres,
  });

  factory GenreResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return GenreResponse(
      genres: List.from(
        (json as List).map(
          (remittance) => Genre.fromJson(
            remittance,
          ),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [];
}
