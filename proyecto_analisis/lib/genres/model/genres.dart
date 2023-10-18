class GenresResponse {
  final List<Genre> users;

  GenresResponse({
    required this.users,
  });

  factory GenresResponse.fromJson(List<dynamic> json) => GenresResponse(
      users: List.from(
        (json).map(
              (user) => Genre.fromJson(
            user,
          ),
        ),
      ));
}
class Genre {
  final String idGenero;
  final String nombre;

  Genre({
    required this.idGenero,
    required this.nombre,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        idGenero: json["IdGenero"],
        nombre: json["Nombre"],
      );
}
