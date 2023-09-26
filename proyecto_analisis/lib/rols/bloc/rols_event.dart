abstract class RolsEvent {
  const RolsEvent();
}

class Rols extends RolsEvent {}

class MenuOptions extends RolsEvent {
  final int rols;

  MenuOptions(this.rols);
}
