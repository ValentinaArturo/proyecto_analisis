import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/models/success_response.dart';
import 'package:proyecto_analisis/common/security/encrypt.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/signUp/model/genre_response.dart';
import 'package:proyecto_analisis/userDetail/bloc/user_detail_event.dart';
import 'package:proyecto_analisis/userDetail/bloc/user_detail_state.dart';
import 'package:proyecto_analisis/userDetail/service/user_detail_service.dart';

class UserDetailBloc extends BaseBloc<UserDetailEvent, BaseState> {
  UserDetailBloc({
    required this.service,
    required this.repository,
  }) : super(UserDetailInitial()) {
    on<UserDetail>(userDetail);
    on<Genre>(genre);
  }

  final UserDetailService service;
  final UserRepository repository;

  Future<void> userDetail(
    UserDetail event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      UserDetailInProgress(),
    );

    try {
      final response = await service.userDetail(
        email: event.email,
        name: event.name,
        lastName: event.lastName,
        birthDate: event.birthDate,
        genre: event.genre,
        phone: event.phone,

      );

      if (response.data['status'] == 401) {
        emit(
          UserDetailError(
            response.data['msg'],
          ),
        );
      } else if (response.data['status'] == 200) {
        final success = SuccessResponse.fromJson(
          response.data!,
        );
        emit(
          UserDetailSuccess(
            successResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        UserDetailError(
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
      UserDetailInProgress(),
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
        UserDetailError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
