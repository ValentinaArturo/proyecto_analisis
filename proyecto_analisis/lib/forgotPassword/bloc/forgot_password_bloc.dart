import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/models/success_response.dart';
import 'package:proyecto_analisis/common/security/hash.dart';
import 'package:proyecto_analisis/forgotPassword/bloc/forgot_password_event.dart';
import 'package:proyecto_analisis/forgotPassword/bloc/forgot_password_state.dart';
import 'package:proyecto_analisis/forgotPassword/service/forgot_password_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

class ForgotPasswordBloc extends BaseBloc<ForgotPasswordEvent, BaseState> {
  ForgotPasswordBloc({required this.service, required this.userRepository})
      : super(ForgotPasswordInitial()) {
    on<ForgotPassword>(forgotPassword);
  }

  final ForgotPasswordService service;
  final UserRepository userRepository;

  Future<void> forgotPassword(
    ForgotPassword event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      ForgotPasswordInProgress(),
    );

    try {
      final response = await service.forgotPassword(
        newPassword: Hash.hash(
          event.newPassword,
        ),
        email: await userRepository.getEmail(),
        oldPassword: Hash.hash(
          event.oldPassword,
        ),
      );

      if (response.data['status'] == 401) {
        emit(
          ForgotPasswordError(
            response.data['msg'],
          ),
        );
      } else if (response.data['status'] == 200) {
        final success = SuccessResponse.fromJson(
          response.data!,
        );
        emit(
          ForgotPasswordSuccess(
            successResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        ForgotPasswordError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
