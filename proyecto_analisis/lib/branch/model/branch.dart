class BranchResponse {
  final List<Branch> branches;

  BranchResponse({
    required this.branches,
  });

  factory BranchResponse.fromJson(List<dynamic> json) => BranchResponse(
      branches: List<Branch>.from(
        json.map(
              (branch) => Branch.fromJson(branch),
        ),
      ));
}

class Branch {
  final String idBranch;
  final String nombre;
  final String direccion;
  final String idEmpresa;
  final DateTime fechaCreacion;
  final String usuarioCreacion;
  final dynamic fechaModificacion;
  final dynamic usuarioModificacion;

  Branch({
    required this.idBranch,
    required this.nombre,
    required this.direccion,
    required this.idEmpresa,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    idBranch: json["IdSucursal"],
    nombre: json["Nombre"],
    direccion: json["Direccion"],
    idEmpresa: json["IdEmpresa"],
    fechaCreacion: DateTime.parse(json["FechaCreacion"]),
    usuarioCreacion: json["UsuarioCreacion"],
    fechaModificacion: json["FechaModificacion"],
    usuarioModificacion: json["UsuarioModificacion"],
  );

  Map<String, dynamic> toJson() => {
    "IdSucursal": idBranch,
    "Nombre": nombre,
    "Direccion": direccion,
    "IdEmpresa": idEmpresa,
    "FechaCreacion": fechaCreacion.toIso8601String(),
    "UsuarioCreacion": usuarioCreacion,
    "FechaModificacion": fechaModificacion,
    "UsuarioModificacion": usuarioModificacion,
  };
}
