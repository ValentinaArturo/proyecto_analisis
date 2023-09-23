import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/rol/bloc/rol_event.dart';
import 'package:proyecto_analisis/rol/bloc/rol_state.dart';
import 'package:proyecto_analisis/rol/model/menu_response.dart';
import 'package:proyecto_analisis/rol/model/rol_response.dart';
import 'package:proyecto_analisis/rol/service/rol_service.dart';

class RolBloc extends BaseBloc<RolEvent, BaseState> {
  RolBloc({required this.service, required this.userRepository})
      : super(RolInitial()) {
    on<Rol>(rol);
    on<MenuOptions>(menu);
  }

  final RolService service;
  final UserRepository userRepository;

  Future<void> rol(
    Rol event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      RolInProgress(),
    );

    try {
      final response = await service.rol(
        email: await userRepository.getId(),
      );

      if (response.data['status'] == 401) {
        emit(
          RolError(
            response.data['msg'],
          ),
        );
      } else if (response.data['status'] == 200) {
        final success = RolResponse.fromJson(
          response.data!,
        );
        emit(
          RolSuccess(
            rolResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        RolError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> menu(
    MenuOptions event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      RolInProgress(),
    );

    try {
      final response = await service.options(
        name: await userRepository.getId(),
        rol: event.rol,
      );

      if (response.data['status'] == 401) {
        emit(
          RolError(
            response.data['msg'],
          ),
        );
      } else if (response.data['status'] == 200) {
        final success = MenuResponse.fromJson(
          response.data!,
        );
        emit(
          OptionSuccess(
            menuResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        RolError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
