import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/company/model/company.dart';
import 'package:proyecto_analisis/company/model/company.dart' as model;
import 'package:proyecto_analisis/department/model/department.dart';
import 'package:proyecto_analisis/department/service/department_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:supercharged/supercharged.dart';

part 'department_event.dart';

part 'department_state.dart';

class DepartmentBloc extends BaseBloc<DepartmentEvent, BaseState> {
  DepartmentBloc({
    required this.service,
    required this.userRepository,
  }) : super(DepartmentInitial()) {
    on<Department>(department);
    on<DepartmentCreate>(departmentCreate);
    on<DepartmentEdit>(departmentEdit);
    on<DepartmentDelete>(departmentDelete);
    on<Company>(company);
  }

  final DepartmentService service;
  final UserRepository userRepository;

  Future<void> company(
    Company event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      DepartmentInProgress(),
    );

    try {
      final response = await service.company();

      if (response.statusCode == 401) {
        emit(
          DepartmentError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = model.CompanyResponse.fromJson(
          response.data!,
        );
        emit(
          CompanySuccess(
            companyResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        DepartmentError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> department(
    Department event,
    Emitter<BaseState> emit,
  ) async {
    emit(DepartmentInProgress());

    try {
      final response = await service.department();

      if (response.statusCode == 401) {
        emit(DepartmentError(response.data['msg']));
      } else if (response.statusCode == 200) {
        final success = DepartmentResponse.fromJson(response.data!);
        emit(DepartmentSuccess(departmentResponse: success));
      }
    } on DioError catch (dioError) {
      emit(DepartmentError(dioError.response!.data['msg']));
    }
  }

  Future<void> departmentCreate(
    DepartmentCreate event,
    Emitter<BaseState> emit,
  ) async {
    emit(DepartmentInProgress());

    try {
      final response = await service.createDepartment(
        nombre: event.nombre,
        usuarioModificacion: event.usuarioModificacion,
        idEmpresa: event.idEmpresa.toInt()!,
      );

      if (response.statusCode == 401) {
        emit(DepartmentError(response.data['msg']));
      } else if (response.statusCode == 200) {
        emit(DepartmentCreateSuccess());
      }
    } on DioError catch (dioError) {
      emit(DepartmentError(dioError.response!.data['msg']));
    }
  }

  Future<void> departmentEdit(
    DepartmentEdit event,
    Emitter<BaseState> emit,
  ) async {
    emit(DepartmentInProgress());

    try {
      final response = await service.editDepartment(
        nombre: event.nombre,
        usuarioModificacion: event.usuarioModificacion,
        idEmpresa: event.idEmpresa.toInt()!,
        idDepartamento: event.idDepartamento.toInt()!,
      );

      if (response.statusCode == 401) {
        emit(DepartmentError(response.data['msg']));
      } else if (response.statusCode == 200) {
        emit(DepartmentEditSuccess());
      }
    } on DioError catch (dioError) {
      emit(DepartmentError(dioError.response!.data['msg']));
    }
  }

  Future<void> departmentDelete(
    DepartmentDelete event,
    Emitter<BaseState> emit,
  ) async {
    emit(DepartmentInProgress());

    try {
      final response = await service.departmentDelete(id: event.id);

      if (response.statusCode == 401) {
        emit(DepartmentError(response.data['msg']));
      } else if (response.statusCode == 200) {
        emit(DepartmentDeleteSuccess());
      }
    } on DioError catch (dioError) {
      emit(DepartmentError(dioError.response!.data['msg']));
    }
  }
}
