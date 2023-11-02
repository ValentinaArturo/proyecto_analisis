class DocumentResponse {
  final List<Document> documents;

  DocumentResponse({
    required this.documents,
  });

  factory DocumentResponse.fromJson(List<dynamic> json) {
    return DocumentResponse(
      documents: List<Document>.from(
        json.map((status) => Document.fromJson(status)),
      ),
    );
  }
}

class Document {
  final String idTipoDocumento;
  final String idPersona;
  final String noDocumento;
  final dynamic fechaCreacion;
  final String usuarioCreacion;
  final dynamic fechaModificacion;
  final dynamic usuarioModificacion;

  Document({
    required this.idTipoDocumento,
    required this.idPersona,
    required this.noDocumento,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        idTipoDocumento: json["IdTipoDocumento"],
        idPersona: json["IdPersona"],
        noDocumento: json["NoDocumento"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        usuarioCreacion: json["UsuarioCreacion"],
        fechaModificacion: json["FechaModificacion"],
        usuarioModificacion: json["UsuarioModificacion"],
      );
}
