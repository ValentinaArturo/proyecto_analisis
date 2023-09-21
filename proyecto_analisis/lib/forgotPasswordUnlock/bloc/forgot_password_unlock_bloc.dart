import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/models/success_response.dart';
import 'package:proyecto_analisis/common/security/hash.dart';
import 'package:proyecto_analisis/forgotPasswordUnlock/bloc/forgot_password_unlock_event.dart';
import 'package:proyecto_analisis/forgotPasswordUnlock/bloc/forgot_password_unlock_state.dart';
import 'package:proyecto_analisis/forgotPasswordUnlock/service/forgot_password_unlock_service.dart';

class ForgotPasswordUnlockBloc
    extends BaseBloc<ForgotPasswordUnlockEvent, BaseState> {
  ForgotPasswordUnlockBloc({
    required this.service,
  }) : super(ForgotPasswordUnlockInitial()) {
    on<ForgotPasswordUnlock>(forgotPasswordUnlock);
  }

  final ForgotPasswordUnlockService service;

  Future<void> forgotPasswordUnlock(
    ForgotPasswordUnlock event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      ForgotPasswordUnlockInProgress(),
    );

    try {
      final response = await service.forgotPasswordUnlock(
        newPassword: Hash.hash(
          event.newPassword,
        ),
        email: event.email,
        id1: event.id1,
        id2: event.id2,
        id3: event.id3,
        q1: event.q1,
        q2: event.q2,
        q3: event.q3,
      );

      if (response.data['status'] == 401) {
        emit(
          ForgotPasswordUnlockError(
            response.data['msg'],
          ),
        );
      } else if (response.data['status'] == 200) {
        final success = SuccessResponse.fromJson(
          response.data!,
        );
        emit(
          ForgotPasswordUnlockSuccess(
            successResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        ForgotPasswordUnlockError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
