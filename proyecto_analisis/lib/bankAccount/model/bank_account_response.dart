class BankAccountResponse {
  final List<BankAccount> bank;

  BankAccountResponse({
    required this.bank,
  });

  factory BankAccountResponse.fromJson(List<dynamic> json) {
    return BankAccountResponse(
      bank: List<BankAccount>.from(
        json.map((status) => BankAccount.fromJson(status)),
      ),
    );
  }
}

class BankAccount {
  final String idCuentaBancaria;
  final String idEmpleado;
  final String idBanco;
  final String numeroDeCuenta;
  final String activa;
  final dynamic fechaCreacion;
  final String usuarioCreacion;
  final dynamic fechaModificacion;
  final dynamic usuarioModificacion;

  BankAccount({
    required this.idCuentaBancaria,
    required this.idEmpleado,
    required this.idBanco,
    required this.numeroDeCuenta,
    required this.activa,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        idCuentaBancaria: json["IdCuentaBancaria"],
        idEmpleado: json["IdEmpleado"],
        idBanco: json["IdBanco"],
        numeroDeCuenta: json["NumeroDeCuenta"],
        activa: json["Activa"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        usuarioCreacion: json["UsuarioCreacion"],
        fechaModificacion: json["FechaModificacion"],
        usuarioModificacion: json["UsuarioModificacion"],
      );
}
