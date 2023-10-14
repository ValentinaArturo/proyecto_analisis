
class Questions {
  final int status;
  final List<Datum> data;

  Questions({
    required this.status,
    required this.data,
  });

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  final String pregunta;

  Datum({
    required this.pregunta,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    pregunta: json["Pregunta"],
  );

  Map<String, dynamic> toJson() => {
    "Pregunta": pregunta,
  };
}
