import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/modules/model/modules.dart';
import 'package:proyecto_analisis/modules/service/modules_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

part 'modules_event.dart';
part 'modules_state.dart';

class ModulesBloc extends BaseBloc<ModulesEvent, BaseState> {
  ModulesBloc({required this.service, required this.userRepository})
      : super(ModulesInitial()) {
    on<Modules>(modules);
  }

  final ModulesService service;
  final UserRepository userRepository;

  Future<void> modules(
    Modules event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      ModulesInProgress(),
    );

    try {
      final response = await service.modules();

      if (response.statusCode == 401) {
        emit(
          ModulesError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = ModulesResponse.fromJson(
          response.data!,
        );
        emit(
          ModulesSuccess(
            modulesResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        ModulesError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> modulesCreate(
    ModuleCreate event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      ModulesInProgress(),
    );

    try {
      final response = await service.modulesCreate(
        name: event.name,
        menuOrder: event.menuOrder,
        userCreate: event.nameCreate,
      );

      if (response.statusCode == 401) {
        emit(
          ModulesError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          ModulesCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        ModulesError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> moduleEdit(
    ModuleEdit event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      ModulesInProgress(),
    );

    try {
      final response = await service.modulesEdit(
        name: event.name,
        id: event.id,
        userCreate: event.nameCreate,
        menuOrder: event.menuOrder,
      );

      if (response.statusCode == 401) {
        emit(
          ModulesError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          ModulesEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        ModulesError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> moduleDelete(
    ModuleDelete event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      ModulesInProgress(),
    );

    try {
      final response = await service.modulesDelete(
        id: event.id,
      );

      if (response.statusCode == 401) {
        emit(
          ModulesError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          ModulesDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        ModulesError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
