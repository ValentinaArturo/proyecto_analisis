import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/models/success_response.dart';
import 'package:proyecto_analisis/common/security/hash.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/signUp/bloc/sign_up_event.dart';
import 'package:proyecto_analisis/signUp/bloc/sign_up_state.dart';
import 'package:proyecto_analisis/signUp/model/genre_response.dart';
import 'package:proyecto_analisis/signUp/service/sign_up_service.dart';

class SignUpBloc extends BaseBloc<SignUpEvent, BaseState> {
  SignUpBloc({
    required this.service,
    required this.repository,
  }) : super(SignUpInitial()) {
    on<SignUp>(signUp);
    on<Genre>(genre);
  }

  final SignUpService service;
  final UserRepository repository;

  Future<void> signUp(
    SignUp event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      SignUpInProgress(),
    );

    try {
      final response = await service.signUp(
        password: Hash.hash(
          event.password,
        ),
        email: event.email,
        name: event.name,
        lastName: event.lastName,
        birthDate: event.birthDate,
        genre: event.genre,
        phone: event.phone,
        id1: event.id1,
        id2: event.id2,
        id3: event.id3,
        q1: event.q1,
        q2: event.q2,
        q3: event.q3,
      );

      if (response.data['status'] == 401) {
        emit(
          SignUpError(
            response.data['msg'],
          ),
        );
      } else if (response.data['status'] == 200) {
        final success = SuccessResponse.fromJson(
          response.data!,
        );
        emit(
          SignUpSuccess(
            successResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        SignUpError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> genre(
    Genre event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      SignUpInProgress(),
    );

    try {
      final response = await service.genre();

      final genreResponse = GenreResponse.fromJson(
        response.data!,
      );

      emit(
        GenreSuccess(
          genreResponse: genreResponse,
        ),
      );
    } on DioError catch (dioError) {
      emit(
        SignUpError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
