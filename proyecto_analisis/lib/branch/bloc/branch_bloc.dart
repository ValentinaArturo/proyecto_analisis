import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:proyecto_analisis/branch/sevice/branch_service.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/branch/model/branch.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends BaseBloc<BranchEvent, BaseState> {
  BranchBloc({
    required this.service,
    required this.userRepository,
  }) : super(BranchInitial()) {
    on<Branch>(branch);
    on<BranchCreate>(branchCreate);
    on<BranchEdit>(branchEdit);
    on<BranchDelete>(branchDelete);
  }

  final BranchService service;
  final UserRepository userRepository;

  Future<void> branch(
      Branch event,
      Emitter<BaseState> emit,
      ) async {
    emit(
      BranchInProgress(),
    );

    try {
      final response = await service.branch();

      if (response.statusCode == 401) {
        emit(
          BranchError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = BranchResponse.fromJson(
          response.data!,
        );
        emit(
          BranchSuccess(
            branchResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        BranchError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> branchCreate(
      BranchCreate event,
      Emitter<BaseState> emit,
      ) async {
    emit(
      BranchInProgress(),
    );

    try {
      final response = await service.branchCreate(
        id: event.id,
        nombre: event.nombre,
        direccion: event.direccion,
        idEmpresa: event.idEmpresa,
        usuarioCreacion: event.usuarioCreacion,
      );

      if (response.statusCode == 401) {
        emit(
          BranchError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          BranchCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        BranchError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> branchEdit(
      BranchEdit event,
      Emitter<BaseState> emit,
      ) async {
    emit(
      BranchInProgress(),
    );

    try {
      final response = await service.branchEdit(
        id: event.id,
        idBranch: event.idBranch,
        nombre: event.nombre,
        direccion: event.direccion,
        idEmpresa: event.idEmpresa,
        usuarioCreacion: event.usuarioCreacion,
      );

      if (response.statusCode == 401) {
        emit(
          BranchError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          BranchEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        BranchError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> branchDelete(
      BranchDelete event,
      Emitter<BaseState> emit,
      ) async {
    emit(
      BranchInProgress(),
    );

    try {
      final response = await service.branchDelete(
        idBranch: event.idBranch,
      );

      if (response.statusCode == 401) {
        emit(
          BranchError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          BranchDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        BranchError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
