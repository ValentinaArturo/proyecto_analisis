import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/status/model/status.dart';
import 'package:proyecto_analisis/status/service/status_service.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends BaseBloc<StatusEvent, BaseState> {
  StatusBloc({
    required this.service,
    required this.userRepository,
  }) : super(StatusInitial()) {
    on<Status>(status);
    on<StatusCreate>(statusCreate);
    on<StatusEdit>(statusEdit);
    on<StatusDelete>(statusDelete);
  }

  final StatusService service;
  final UserRepository userRepository;

  Future<void> status(
    Status event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      StatusInProgress(),
    );

    try {
      final response = await service.status();

      if (response.statusCode == 401) {
        emit(
          StatusError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = StatusResponse.fromJson(
          response.data!,
        );
        emit(
          StatusSuccess(
            statusResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        StatusError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> statusCreate(
    StatusCreate event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      StatusInProgress(),
    );

    try {
      final response = await service.createStatus(
        nombre: event.nombre,
        usuarioModificacion: event.usuarioModificacion,
      );

      if (response.statusCode == 401) {
        emit(
          StatusError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          StatusCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        StatusError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> statusEdit(
    StatusEdit event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      StatusInProgress(),
    );

    try {
      final response = await service.editStatus(
        nombre: event.nombre,
        usuarioModificacion: event.usuarioModificacion,
        idStatusUsuario: event.idStatusUsuario,
      );

      if (response.statusCode == 401) {
        emit(
          StatusError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          StatusEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        StatusError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> statusDelete(
    StatusDelete event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      StatusInProgress(),
    );

    try {
      final response = await service.statusDelete(
        id: event.id,
      );

      if (response.statusCode == 401) {
        emit(
          StatusError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          StatusDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        StatusError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
