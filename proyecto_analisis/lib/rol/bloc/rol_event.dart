abstract class RolEvent {
  const RolEvent();
}

class Rol extends RolEvent {}

class MenuOptions extends RolEvent {
  final int rol;

  MenuOptions(this.rol);
}
