class RolResponse {
  final int status;
  final List<Datum> data;

  RolResponse({
    required this.status,
    required this.data,
  });

  factory RolResponse.fromJson(Map<String, dynamic> json) => RolResponse(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  final String idRole;
  final String nombre;

  Datum({
    required this.idRole,
    required this.nombre,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idRole: json["IdRole"],
        nombre: json["Nombre"],
      );
}
