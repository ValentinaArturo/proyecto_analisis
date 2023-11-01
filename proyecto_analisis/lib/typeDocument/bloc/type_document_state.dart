part of 'type_document_bloc.dart';

abstract class TypeDocumentState extends BaseState {}

class TypeDocumentInitial extends TypeDocumentState {}

class TypeDocumentInProgress extends TypeDocumentState {}

class TypeDocumentSuccess extends TypeDocumentState {
  final TypeDocumentResponse success;

  TypeDocumentSuccess({
    required this.success,
  });
}

class TypeDocumentEditSuccess extends TypeDocumentState {}

class TypeDocumentCreateSuccess extends TypeDocumentState {}

class TypeDocumentDeleteSuccess extends TypeDocumentState {}

class TypeDocumentError extends TypeDocumentState {
  final String? error;

  TypeDocumentError(this.error);
}
