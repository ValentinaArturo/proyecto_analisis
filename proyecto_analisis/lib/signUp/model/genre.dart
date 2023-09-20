class Genre {
  final String idGenero;
  final String genero;

  Genre({
    required this.idGenero,
    required this.genero,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        idGenero: json["IdGenero"],
        genero: json["Genero"],
      );

  Map<String, dynamic> toJson() => {
        "IdGenero": idGenero,
        "Genero": genero,
      };
}
