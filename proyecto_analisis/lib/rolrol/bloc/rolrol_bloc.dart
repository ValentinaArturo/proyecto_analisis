import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/rolrol/service/rolrol_service.dart';
import 'package:proyecto_analisis/rolsUser/model/rol.dart';

part 'rolrol_event.dart';
part 'rolrol_state.dart';

class RolRolBloc extends BaseBloc<RolRolEvent, BaseState> {
  RolRolBloc({required this.service, required this.userRepository})
      : super(RolRolInitial()) {
    on<RolRol>(rolRol);
    on<RolCreate>(rolRolCreate);
    on<RolEdit>(rolEdit);
    on<RolDelete>(rolDelete);
  }

  final RolRolService service;
  final UserRepository userRepository;

  Future<void> rolRol(
    RolRol event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      RolRolInProgress(),
    );

    try {
      final response = await service.rolRol();

      if (response.statusCode == 401) {
        emit(
          RolRolError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = RolResponse.fromJson(
          response.data!,
        );
        emit(
          RolRolSuccess(
            rolRolResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        RolRolError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> rolRolCreate(
    RolCreate event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      RolRolInProgress(),
    );

    try {
      final response = await service.rolRolCreate(
        name: event.name,
        userCreate: event.nameCreate,
      );

      if (response.statusCode == 401) {
        emit(
          RolRolError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          RolRolCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        RolRolError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> rolEdit(
    RolEdit event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      RolRolInProgress(),
    );

    try {
      final response = await service.rolRolEdit(
        name: event.name,
        id: event.id,
        userCreate: event.nameCreate,
      );

      if (response.statusCode == 401) {
        emit(
          RolRolError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          RolRolEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        RolRolError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> rolDelete(
    RolDelete event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      RolRolInProgress(),
    );

    try {
      final response = await service.rolRolDelete(
        id: event.id,
      );

      if (response.statusCode == 401) {
        emit(
          RolRolError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          RolRolDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        RolRolError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
