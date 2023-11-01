class OptionResponse {
  final List<Option> option;

  OptionResponse({
    required this.option,
  });

  factory OptionResponse.fromJson(List<dynamic> json) {
    return OptionResponse(
      option: List<Option>.from(
        json.map((status) => Option.fromJson(status)),
      ),
    );
  }
}

class Option {
  final String idOpcion;
  final String idMenu;
  final String nombre;
  final String ordenMenu;
  final String pagina;
  final dynamic fechaCreacion;
  final String usuarioCreacion;
  final dynamic fechaModificacion;
  final dynamic usuarioModificacion;

  Option({
    required this.idOpcion,
    required this.idMenu,
    required this.nombre,
    required this.ordenMenu,
    required this.pagina,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        idOpcion: json["IdOpcion"],
        idMenu: json["IdMenu"],
        nombre: json["Nombre"],
        ordenMenu: json["OrdenMenu"],
        pagina: json["Pagina"],
        fechaCreacion: json["FechaCreacion"],
        usuarioCreacion: json["UsuarioCreacion"],
        fechaModificacion: json["FechaModificacion"],
        usuarioModificacion: json["UsuarioModificacion"],
      );
}
