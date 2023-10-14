import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/genres/bloc/genres_event.dart';
import 'package:proyecto_analisis/genres/bloc/genres_state.dart';
import 'package:proyecto_analisis/genres/model/genres.dart';
import 'package:proyecto_analisis/genres/service/genres_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

class GenresBloc extends BaseBloc<GenresEvent, BaseState> {
  GenresBloc({required this.service, required this.userRepository})
      : super(GenresInitial()) {
    on<Genres>(genres);
    on<GenreEdit>(genreEdit);
    on<GenreDelete>(genreDelete);
    on<GenreCreate>(genresCreate);

  }

  final GenresService service;
  final UserRepository userRepository;

  Future<void> genres(
    Genres event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      GenresInProgress(),
    );

    try {
      final response = await service.genres();

      if (response.statusCode == 401) {
        emit(
          GenresError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = GenresResponse.fromJson(
          response.data!,
        );
        emit(
          GenresSuccess(
            genresResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        GenresError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> genresCreate(
    GenreCreate event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      GenresInProgress(),
    );

    try {
      final response = await service.genresCreate(
        name: event.name,
        userCreate: event.nameCreate,
      );

      if (response.statusCode == 401) {
        emit(
          GenresError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          GenresCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        GenresError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> genreEdit(
    GenreEdit event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      GenresInProgress(),
    );

    try {
      final response = await service.genresEdit(
        name: event.name,
        id: event.id,
        userCreate: event.nameCreate,
      );

      if (response.statusCode == 401) {
        emit(
          GenresError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          GenresEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        GenresError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> genreDelete(
    GenreDelete event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      GenresInProgress(),
    );

    try {
      final response = await service.genresDelete(
        id: event.id,
      );

      if (response.statusCode == 401) {
        emit(
          GenresError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          GenresDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        GenresError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
