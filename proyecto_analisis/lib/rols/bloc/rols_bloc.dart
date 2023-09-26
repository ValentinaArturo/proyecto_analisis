import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/rols/bloc/rols_event.dart';
import 'package:proyecto_analisis/rols/bloc/rols_state.dart';
import 'package:proyecto_analisis/rols/model/user_response.dart';
import 'package:proyecto_analisis/rols/service/rols_service.dart';

class RolsBloc extends BaseBloc<RolsEvent, BaseState> {
  RolsBloc({required this.service, required this.userRepository})
      : super(RolsInitial()) {
    on<Rols>(rols);
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
      final response = await service.users();

      if (response.data['status'] == 401) {
        emit(
          RolsError(
            response.data['msg'],
          ),
        );
      } else if (response.data['status'] == 200) {
        final success = UserResponse.fromJson(
          response.data!,
        );
        emit(
          RolsSuccess(
            userResponse: success,
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
