import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/security/encrypt.dart';
import 'package:proyecto_analisis/login/bloc/login_event.dart';
import 'package:proyecto_analisis/login/bloc/login_state.dart';
import 'package:proyecto_analisis/login/model/user_session.dart';
import 'package:proyecto_analisis/login/service/login_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/signUp/model/policy_response.dart';

class LoginBloc extends BaseBloc<LoginEvent, BaseState> {
  LoginBloc({
    required this.service,
    required this.repository,
  }) : super(LoginInitial()) {
    on<LoginWithEmailPassword>(loginWithPassword);
    on<PolicyEm>(policy);
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
        password: Encrypt.encryptPassword(
          event.password,
        ),
        email: event.email,
      );

      if (response.data['status'] == 401) {
        emit(
          LoginError(
            response.data['msg'],
          ),
        );
      } else if (response.data['status'] == 402) {
        emit(
          LoginError(
            '402',
          ),
        );
      } else if (response.data['status'] == 33) {
        emit(
          LoginError(
            '33',
          ),
        );
      } else if (response.data['status'] == 200) {
        final userSession = UserSession.fromJson(
          response.data!,
        );

        await repository.setToken(
          userSession.token!,
        );
        await repository.setId(
          userSession.data!.idUsuario,
        );
        await repository.setName(
          '${userSession.data!.nombreUsuario} ${userSession.data!.apellido}',
        );
        emit(
          LoginSuccess(
            userSession: userSession,
          ),
        );
      } else {
        emit(
          LoginError(
            response.data['msg'],
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        LoginError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> policy(
    PolicyEm event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      LoginInProgress(),
    );

    try {
      final response = await service.policy();

      final policyResponse = PolicyResponse.fromJson(
        response.data!,
      );

      emit(
        PolicySuccess(
          policyResponse,
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
