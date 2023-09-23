import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/models/success_response.dart';
import 'package:proyecto_analisis/forgotPasswordUnlock/bloc/forgot_password_unlock_event.dart';
import 'package:proyecto_analisis/forgotPasswordUnlock/bloc/forgot_password_unlock_state.dart';
import 'package:proyecto_analisis/forgotPasswordUnlock/service/forgot_password_unlock_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/signUp/model/question.dart';

class ForgotPasswordUnlockBloc
    extends BaseBloc<ForgotPasswordUnlockEvent, BaseState> {
  ForgotPasswordUnlockBloc({
    required this.service,
    required this.repository,
  }) : super(ForgotPasswordUnlockInitial()) {
    on<ForgotPasswordUnlock>(forgotPasswordUnlock);
    on<Question>(question);
  }

  final ForgotPasswordUnlockService service;
  final UserRepository repository;

  Future<void> forgotPasswordUnlock(
    ForgotPasswordUnlock event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      ForgotPasswordUnlockInProgress(),
    );

    try {
      final response = await service.forgotPasswordUnlock(
        newPassword: await repository.getPassword(),
        email: await repository.getEmail(),
        id1: event.id1,
        id2: event.id2,
        id3: event.id3,
        q1: event.q1,
        q2: event.q2,
        q3: event.q3,
      );

      if (response.data['status'] == 400) {
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

  Future<void> question(
    Question event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      ForgotPasswordUnlockInProgress(),
    );

    try {
      final response = await service.question(
        email: await repository.getEmail(),
      );

      final question = QuestionRepsonse.fromJson(
        response.data!,
      );

      emit(
        QuestionsSuccess(
          question,
        ),
      );
    } on DioError catch (dioError) {
      emit(
        ForgotPasswordUnlockError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
