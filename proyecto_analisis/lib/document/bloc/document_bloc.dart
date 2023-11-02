import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/document/model/document_response.dart';
import 'package:proyecto_analisis/document/service/document_service.dart';
import 'package:proyecto_analisis/person/model/person.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/typeDocument/model/type_document_response.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends BaseBloc<DocumentEvent, BaseState> {
  DocumentBloc({
    required this.service,
    required this.userRepository,
  }) : super(DocumentInitial()) {
    on<GetDocument>(getDocuments);
    on<CreateDocument>(createDocument);
    on<EditDocument>(editDocument);
    on<DeleteDocument>(deleteDocument);
    on<Person>(person);
    on<GetTypeDocument>(getTypeDocuments);
  }

  final DocumentService service;
  final UserRepository userRepository;

  Future<void> person(
    Person event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      DocumentInProgress(),
    );

    try {
      final response = await service.person();

      if (response.statusCode == 401) {
        emit(
          DocumentError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = PersonResponse.fromJson(
          response.data!,
        );
        emit(
          PersonSuccess(
            personResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        DocumentError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> getTypeDocuments(
    GetTypeDocument event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      DocumentInProgress(),
    );

    try {
      final response = await service.getTypeDocument();

      if (response.statusCode == 401) {
        emit(
          DocumentError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = TypeDocumentResponse.fromJson(
          response.data!,
        );
        emit(
          TypeDocumentSuccess(
            success: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        DocumentError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> getDocuments(
    GetDocument event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      DocumentInProgress(),
    );

    try {
      final response = await service.getDocument();

      if (response.statusCode == 401) {
        emit(
          DocumentError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = DocumentResponse.fromJson(
          response.data!,
        );
        emit(
          DocumentSuccess(
            success: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        DocumentError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> createDocument(
    CreateDocument event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      DocumentInProgress(),
    );

    try {
      final response = await service.documentCreate(
        idDocument: event.idDocument,
        idPersona: event.idPersona,
        idUsuarioModificacion: event.usuarioModificacion,
        noDocument: event.noDocument,
      );

      if (response.statusCode == 401) {
        emit(
          DocumentError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          DocumentCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        DocumentError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> editDocument(
    EditDocument event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      DocumentInProgress(),
    );

    try {
      final response = await service.documentEdit(
        idDocument: event.idDocument,
        idPersona: event.idPersona,
        idUsuarioModificacion: event.usuarioModificacion,
        noDocument: event.noDocument,
      );

      if (response.statusCode == 401) {
        emit(
          DocumentError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          DocumentEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        DocumentError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> deleteDocument(
    DeleteDocument event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      DocumentInProgress(),
    );

    try {
      final response = await service.documentDelete(
        idDocument: event.idDocument,
        idPersona: event.idPersona,
        noDocument: event.noDocument,
      );

      if (response.statusCode == 401) {
        emit(
          DocumentError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          DocumentDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        DocumentError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
