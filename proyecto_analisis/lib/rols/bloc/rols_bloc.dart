import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/rol/model/menu_response.dart';
import 'package:proyecto_analisis/rol/model/rol_response.dart';
import 'package:proyecto_analisis/rols/bloc/rols_event.dart';
import 'package:proyecto_analisis/rols/bloc/rols_state.dart';
import 'package:proyecto_analisis/rols/service/rols_service.dart';

class RolsBloc extends BaseBloc<RolsEvent, BaseState> {
  RolsBloc({required this.service, required this.userRepository})
      : super(RolsInitial()) {
    on<Rols>(rols);
    on<MenuOptions>(menu);
  }

  final RolsService service;
  final UserRepository userRepository;

  Future<void> rols(
    Rols event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      RolsInProgress(),
    );

    try {
      final response = await service.rols(
        email: await userRepository.getId(),
      );

      if (response.data['status'] == 401) {
        emit(
          RolsError(
            response.data['msg'],
          ),
        );
      } else if (response.data['status'] == 200) {
        final success = RolResponse.fromJson(
          response.data!,
        );
        emit(
          RolsSuccess(
            rolResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        RolsError(
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
      RolsInProgress(),
    );

    try {
      final response = await service.options(
        name: await userRepository.getId(),
        rol: event.rols,
      );

      if (response.data['status'] == 401) {
        emit(
          RolsError(
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
        RolsError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
