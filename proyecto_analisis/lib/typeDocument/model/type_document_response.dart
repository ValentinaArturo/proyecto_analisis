class TypeDocumentResponse {
  final List<TypeDocument> typeDocuments;

  TypeDocumentResponse({
    required this.typeDocuments,
  });

  factory TypeDocumentResponse.fromJson(List<dynamic> json) {
    return TypeDocumentResponse(
      typeDocuments: List<TypeDocument>.from(
        json.map((status) => TypeDocument.fromJson(status)),
      ),
    );
  }
}

class TypeDocument {
  final String idTipoDocumento;
  final String nombre;
  final dynamic fechaCreacion;
  final String usuarioCreacion;
  final dynamic fechaModificacion;
  final dynamic usuarioModificacion;

  TypeDocument({
    required this.idTipoDocumento,
    required this.nombre,
    required this.fechaCreacion,
    required this.usuarioCreacion,
    required this.fechaModificacion,
    required this.usuarioModificacion,
  });

  factory TypeDocument.fromJson(Map<String, dynamic> json) => TypeDocument(
        idTipoDocumento: json["IdTipoDocumento"],
        nombre: json["Nombre"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        usuarioCreacion: json["UsuarioCreacion"],
        fechaModificacion: json["FechaModificacion"],
        usuarioModificacion: json["UsuarioModificacion"],
      );
}
