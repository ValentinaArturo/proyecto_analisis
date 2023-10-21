import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/menu/model/menu.dart';
import 'package:proyecto_analisis/menu/service/menu_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends BaseBloc<MenuEvent, BaseState> {
  MenuBloc({
    required this.service,
    required this.userRepository,
  }) : super(MenuInitial()) {
    on<Menu>(menu);
    on<MenuCreate>(menuCreate);
    on<MenuEdit>(menuEdit);
    on<MenuDelete>(menuDelete);
  }

  final MenuService service;
  final UserRepository userRepository;

  Future<void> menu(
    Menu event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      MenuInProgress(),
    );

    try {
      final response = await service.menu();

      if (response.statusCode == 401) {
        emit(
          MenuError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = MenuResponse.fromJson(
          response.data!,
        );
        emit(
          MenuSuccess(
            menuResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        MenuError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> menuCreate(
    MenuCreate event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      MenuInProgress(),
    );

    try {
      final response = await service.menuCreate(
        name: event.name,
        menuOrder: event.menuOrder,
        userCreate: event.nameCreate,
        id: event.id,
      );

      if (response.statusCode == 401) {
        emit(
          MenuError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          MenuCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        MenuError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> menuEdit(
    MenuEdit event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      MenuInProgress(),
    );

    try {
      final response = await service.menuEdit(
        name: event.name,
        id: event.id,
        userCreate: event.nameCreate,
        menuOrder: event.menuOrder,
        idMenu: event.idMenu,
      );

      if (response.statusCode == 401) {
        emit(
          MenuError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          MenuEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        MenuError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> menuDelete(
    MenuDelete event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      MenuInProgress(),
    );

    try {
      final response = await service.menuDelete(
        id: event.id,
      );

      if (response.statusCode == 401) {
        emit(
          MenuError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          MenuDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        MenuError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
