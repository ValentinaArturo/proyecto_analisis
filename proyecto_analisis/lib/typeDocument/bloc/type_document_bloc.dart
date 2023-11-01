import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/typeDocument/model/type_document_response.dart';
import 'package:proyecto_analisis/typeDocument/service/type_document_service.dart';

part 'type_document_event.dart';
part 'type_document_state.dart';

class TypeDocumentBloc extends BaseBloc<TypeDocumentEvent, BaseState> {
  TypeDocumentBloc({
    required this.service,
    required this.userRepository,
  }) : super(TypeDocumentInitial()) {
    on<GetTypeDocument>(getTypeDocuments);
    on<CreateTypeDocument>(createTypeDocument);
    on<EditTypeDocument>(editTypeDocument);
    on<DeleteTypeDocument>(deleteTypeDocument);
  }

  final TypeDocumentService service;
  final UserRepository userRepository;

  Future<void> getTypeDocuments(
      GetTypeDocument event,
      Emitter<BaseState> emit,
      ) async {
    emit(
      TypeDocumentInProgress(),
    );

    try {
      final response = await service.getTypeDocument();

      if (response.statusCode == 401) {
        emit(
          TypeDocumentError(
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
        TypeDocumentError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> createTypeDocument(
      CreateTypeDocument event,
      Emitter<BaseState> emit,
      ) async {
    emit(
      TypeDocumentInProgress(),
    );

    try {
      final response = await service.typeDocumentCreate(
        nombre: event.nombre,
        idUsuarioCreacion: event.idUsuarioModificacion,
      );

      if (response.statusCode == 401) {
        emit(
          TypeDocumentError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          TypeDocumentCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        TypeDocumentError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> editTypeDocument(
      EditTypeDocument event,
      Emitter<BaseState> emit,
      ) async {
    emit(
      TypeDocumentInProgress(),
    );

    try {
      final response = await service.typeDocumentEdit(
        nombre: event.nombre,
        idUsuarioModificacion: event.idUsuarioModificacion,
        idTypeDocument: event.idTypeDocument,
      );

      if (response.statusCode == 401) {
        emit(
          TypeDocumentError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          TypeDocumentEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        TypeDocumentError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> deleteTypeDocument(
      DeleteTypeDocument event,
      Emitter<BaseState> emit,
      ) async {
    emit(
      TypeDocumentInProgress(),
    );

    try {
      final response = await service.typeDocumentDelete(
        idTypeDocument: event.idTypeDocument,
      );

      if (response.statusCode == 401) {
        emit(
          TypeDocumentError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          TypeDocumentDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        TypeDocumentError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
