class QuestionRepsonse {
  final int status;
  final List<Datum> data;

  QuestionRepsonse({
    required this.status,
    required this.data,
  });

  factory QuestionRepsonse.fromJson(Map<String, dynamic> json) => QuestionRepsonse(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  final String pregunta;

  Datum({
    required this.pregunta,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        pregunta: json["Pregunta"],
      );
}
