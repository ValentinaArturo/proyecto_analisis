import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/rols/bloc/rols_event.dart';
import 'package:proyecto_analisis/rols/bloc/rols_state.dart';
import 'package:proyecto_analisis/rols/model/user_response.dart';
import 'package:proyecto_analisis/rols/service/rols_service.dart';
import 'package:proyecto_analisis/rolsUser/model/rol.dart';
import 'package:proyecto_analisis/rolsUser/model/rol_user.dart';

class RolsBloc extends BaseBloc<RolsEvent, BaseState> {
  RolsBloc({required this.service, required this.userRepository})
      : super(RolsInitial()) {
    on<Rols>(rols);
    on<RolsUser>(rolsUser);
    on<RolCreate>(rolsUserCreate);
    on<RolEdit>(rolsUserEdit);
    on<RolDelete>(rolsUserDelete);
    on<RolList>(rolList);
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

      if (response.statusCode == 401) {
        emit(
          RolsError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
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

  Future<void> rolsUser(
    RolsUser event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      RolsInProgress(),
    );

    try {
      final response = await service.rolsUser();

      if (response.statusCode == 401) {
        emit(
          RolsError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = RolUserResponse.fromJson(
          response.data!,
        );
        emit(
          RolsUserSuccess(
            rolUserResponse: success,
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

  Future<void> rolsUserCreate(
    RolCreate event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      RolsInProgress(),
    );

    try {
      final response = await service.rolsSave(
        user: event.user,
        id: event.id,
        userCreate: event.userCreate,
      );

      if (response.statusCode == 401) {
        emit(
          RolsError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          RolsUserCreateSuccess(),
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

  Future<void> rolsUserEdit(
    RolEdit event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      RolsInProgress(),
    );

    try {
      final response = await service.rolsEdit(
        user: event.user,
        id: event.id,
        userCreate: event.userCreate,
      );

      if (response.statusCode == 401) {
        emit(
          RolsError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          RolsUserEditSuccess(),
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

  Future<void> rolsUserDelete(
    RolDelete event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      RolsInProgress(),
    );

    try {
      final response = await service.rolsDelete(
        user: event.user,
        id: event.id,
      );

      if (response.statusCode == 401) {
        emit(
          RolsError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          RolsUserDeleteSuccess(),
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

  Future<void> rolList(
    RolList event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      RolsInProgress(),
    );

    try {
      final response = await service.rolList();

      if (response.statusCode == 401) {
        emit(
          RolsError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = RolResponse.fromJson(
          response.data!,
        );
        emit(
          RolListSuccess(
            success,
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
