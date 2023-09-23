class MenuResponse {
  final int status;
  final List<Datum> data;

  MenuResponse({
    required this.status,
    required this.data,
  });

  factory MenuResponse.fromJson(Map<String, dynamic> json) => MenuResponse(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  final String nombre;
  final String idOpcion;

  Datum({
    required this.nombre,
    required this.idOpcion,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        nombre: json["Nombre"],
        idOpcion: json["IdOpcion"],
      );
}
