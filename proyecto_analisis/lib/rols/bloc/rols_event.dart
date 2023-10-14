abstract class RolsEvent {
  const RolsEvent();
}

class Rols extends RolsEvent {}

class RolsUser extends RolsEvent {}

class RolEdit extends RolsEvent {
  final String user;
  final int id;
  final String userCreate;

  RolEdit({
    required this.user,
    required this.id,
    required this.userCreate,
  });
}

class RolCreate extends RolsEvent {
  final String user;
  final int id;
  final String userCreate;

  RolCreate({
    required this.user,
    required this.id,
    required this.userCreate,
  });
}

class RolDelete extends RolsEvent {
  final String user;
  final int id;

  RolDelete({
    required this.user,
    required this.id,
  });
}
class RolList extends RolsEvent {

}
