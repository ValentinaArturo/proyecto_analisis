part of 'type_document_bloc.dart';

abstract class TypeDocumentEvent {}

class GetTypeDocument extends TypeDocumentEvent {}

class EditTypeDocument extends TypeDocumentEvent {
  final String nombre;
  final String idUsuarioModificacion;
  final int idTypeDocument;

  EditTypeDocument({
    required this.idTypeDocument,
    required this.nombre,
    required this.idUsuarioModificacion,
  });
}

class CreateTypeDocument extends TypeDocumentEvent {
  final String nombre;
  final String idUsuarioModificacion;

  CreateTypeDocument({
    required this.nombre,
    required this.idUsuarioModificacion,
  });
}

class DeleteTypeDocument extends TypeDocumentEvent {
  final String idTypeDocument;

  DeleteTypeDocument({
    required this.idTypeDocument,
  });
}
