class GenreItem {
  final String idGenero;
  final String genero;

  GenreItem({
    required this.idGenero,
    required this.genero,
  });

  factory GenreItem.fromJson(Map<String, dynamic> json) => GenreItem(
        idGenero: json["IdGenero"],
        genero: json["Genero"],
      );

  Map<String, dynamic> toJson() => {
        "IdGenero": idGenero,
        "Genero": genero,
      };
}
