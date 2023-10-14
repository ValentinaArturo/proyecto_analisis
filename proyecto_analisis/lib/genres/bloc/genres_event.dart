
abstract class GenresEvent {}

class Genres extends GenresEvent {}

class GenreEdit extends GenresEvent {
  final String name;
  final int id;
  final String nameCreate;

  GenreEdit({
    required this.name,
    required this.id,
    required this.nameCreate,
  });
}

class GenreCreate extends GenresEvent {
  final String name;
  final String nameCreate;

  GenreCreate({
    required this.name,
    required this.nameCreate,
  });
}

class GenreDelete extends GenresEvent {
  final int id;

  GenreDelete({
    required this.id,
  });
}

