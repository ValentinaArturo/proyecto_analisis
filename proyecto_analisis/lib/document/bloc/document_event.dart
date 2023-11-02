part of 'document_bloc.dart';

abstract class DocumentEvent {}

class GetDocument extends DocumentEvent {}

class Person extends DocumentEvent {}

class GetTypeDocument extends DocumentEvent {}

class EditDocument extends DocumentEvent {
  final String usuarioModificacion;
  final int idDocument;
  final int idPersona;
  final String noDocument;

  EditDocument({
    required this.usuarioModificacion,
    required this.idDocument,
    required this.noDocument,
    required this.idPersona,
  });
}

class DeleteDocument extends DocumentEvent {
  final int idDocument;
  final int idPersona;
  final String noDocument;

  DeleteDocument({
    required this.idDocument,
    required this.noDocument,
    required this.idPersona,
  });
}

class CreateDocument extends DocumentEvent {
  final String usuarioModificacion;
  final int idDocument;
  final int idPersona;
  final String noDocument;

  CreateDocument({
    required this.usuarioModificacion,
    required this.idDocument,
    required this.noDocument,
    required this.idPersona,
  });
}
