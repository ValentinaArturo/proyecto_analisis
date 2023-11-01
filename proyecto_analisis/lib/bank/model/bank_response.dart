class BankResponse {
  final List<Bank> bank;

  BankResponse({
    required this.bank,
  });

  factory BankResponse.fromJson(List<dynamic> json) {
    return BankResponse(
      bank: List<Bank>.from(
        json.map((status) => Bank.fromJson(status)),
      ),
    );
  }
}

class Bank {
  final String idBanco;
  final String nombre;
  final dynamic fechaCreacion;
  final String usuarioCreacion;
  final dynamic fechaModificacion;
  final dynamic usuarioModificacion;

  Bank({
    required this.idBanco,
    required this.nombre,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        idBanco: json["IdBanco"],
        nombre: json["Nombre"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        usuarioCreacion: json["UsuarioCreacion"],
        fechaModificacion: json["FechaModificacion"],
        usuarioModificacion: json["UsuarioModificacion"],
      );
}
