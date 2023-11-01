part of 'option_bloc.dart';

abstract class OptionEvent {}

class GetOption extends OptionEvent {}
class Menu extends OptionEvent {}

class EditOption extends OptionEvent {
  final String nombre;
  final String idUsuarioModificacion;
  final int idMenu;
  final int ordenMenu;
  final String pagina;
  final int idOption;

  EditOption({
    required this.idOption,
    required this.nombre,
    required this.idUsuarioModificacion,
    required this.idMenu,
    required this.ordenMenu,
    required this.pagina,
  });
}

class CreateOption extends OptionEvent {
  final String nombre;
  final String idUsuarioModificacion;
  final int idMenu;
  final int ordenMenu;
  final String pagina;

  CreateOption({
    required this.nombre,
    required this.idUsuarioModificacion,
    required this.idMenu,
    required this.ordenMenu,
    required this.pagina,
  });
}

class DeleteOption extends OptionEvent {
  final String idOption;

  DeleteOption({
    required this.idOption,
  });
}
