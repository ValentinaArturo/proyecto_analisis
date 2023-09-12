import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/security/hash.dart';
import 'package:proyecto_analisis/login/bloc/login_event.dart';
import 'package:proyecto_analisis/login/bloc/login_state.dart';
import 'package:proyecto_analisis/login/model/user_session.dart';
import 'package:proyecto_analisis/login/service/login_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

class LoginBloc extends BaseBloc<LoginEvent, BaseState> {
  LoginBloc({
    required this.service,
    required this.repository,
  }) : super(LoginInitial()) {
    on<LoginWithEmailPassword>(loginWithPassword);
  }

  final LoginService service;
  final UserRepository repository;

  Future<void> loginWithPassword(
    LoginWithEmailPassword event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      LoginInProgress(),
    );

    try {
      final response = await service.loginWithPassword(
        password: Hash.hash(
          event.password,
        ),
        email: event.email,
      );

      final userSession = UserSession.fromJson(
        response.data!,
      );

      await repository.setToken(
        userSession.token,
      );

      emit(
        LoginSuccess(
          userSession: userSession,
        ),
      );
    } on DioError catch (dioError) {
      emit(
        LoginError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
