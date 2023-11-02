part of 'document_bloc.dart';

abstract class DocumentState extends BaseState {}

class DocumentInitial extends DocumentState {}

class DocumentInProgress extends DocumentState {}

class DocumentSuccess extends DocumentState {
  final DocumentResponse success;

  DocumentSuccess({
    required this.success,
  });
}

class DocumentEditSuccess extends DocumentState {}

class DocumentCreateSuccess extends DocumentState {}

class DocumentDeleteSuccess extends DocumentState {}

class DocumentError extends DocumentState {
  final String? error;

  DocumentError(this.error);
}

class TypeDocumentSuccess extends DocumentState {
  final TypeDocumentResponse success;

  TypeDocumentSuccess({
    required this.success,
  });
}

class PersonSuccess extends DocumentState {
  final PersonResponse personResponse;

  PersonSuccess({
    required this.personResponse,
  });
}
