import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/department/model/department.dart';
import 'package:proyecto_analisis/position/model/position.dart';
import 'package:proyecto_analisis/position/service/position_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

part 'position_event.dart';
part 'position_state.dart';

class PositionBloc extends BaseBloc<PositionEvent, BaseState> {
  PositionBloc({
    required this.service,
    required this.userRepository,
  }) : super(PositionInitial()) {
    on<Position>(position);
    on<PositionCreate>(positionCreate);
    on<PositionEdit>(positionEdit);
    on<PositionDelete>(positionDelete);
    on<Department>(department);
  }

  final PositionService service;
  final UserRepository userRepository;
  Future<void> department(
      Department event,
      Emitter<BaseState> emit,
      ) async {
    emit(PositionInProgress());

    try {
      final response = await service.department();

      if (response.statusCode == 401) {
        emit(PositionError(response.data['msg']));
      } else if (response.statusCode == 200) {
        final success = DepartmentResponse.fromJson(response.data!);
        emit(DepartmentSuccess(departmentResponse: success));
      }
    } on DioError catch (dioError) {
      emit(PositionError(dioError.response!.data['msg']));
    }
  }
  Future<void> position(
    Position event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      PositionInProgress(),
    );

    try {
      final response = await service.position();

      if (response.statusCode == 401) {
        emit(
          PositionError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = PositionResponse.fromJson(
          response.data!,
        );
        emit(
          PositionSuccess(
            positionResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        PositionError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> positionCreate(
    PositionCreate event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      PositionInProgress(),
    );

    try {
      final response = await service.createPosition(
        nombre: event.nombre,
        idDepartamento: event.idDepartamento,
        usuarioModificacion: event.usuarioModificacion,
      );

      if (response.statusCode == 401) {
        emit(
          PositionError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          PositionCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        PositionError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> positionEdit(
    PositionEdit event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      PositionInProgress(),
    );

    try {
      final response = await service.editPosition(
        nombre: event.nombre,
        idDepartamento: event.idDepartamento,
        usuarioModificacion: event.usuarioModificacion,
        idPuesto: event.idPuesto,
      );

      if (response.statusCode == 401) {
        emit(
          PositionError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          PositionEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        PositionError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> positionDelete(
    PositionDelete event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      PositionInProgress(),
    );

    try {
      final response = await service.positionDelete(
        id: event.id,
      );

      if (response.statusCode == 401) {
        emit(
          PositionError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          PositionDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        PositionError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
