import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/employee/model/employee.dart';
import 'package:proyecto_analisis/employee/service/employee_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends BaseBloc<EmployeeEvent, BaseState> {
  EmployeeBloc({
    required this.service,
    required this.userRepository,
  }) : super(EmployeeInitial()) {
    on<Employee>(employee);
    on<EmployeeCreate>(employeeCreate);
    on<EmployeeEdit>(employeeEdit);
    on<EmployeeDelete>(employeeDelete);
  }

  final EmployeeService service;
  final UserRepository userRepository;

  Future<void> employee(Employee event, Emitter<BaseState> emit) async {
    emit(EmployeeInProgress());

    try {
      final response = await service.employee();

      if (response.statusCode == 401) {
        emit(EmployeeError(response.data['msg']));
      } else if (response.statusCode == 200) {
        final success = EmployeeResponse.fromJson(response.data!);
        emit(EmployeeSuccess(employeeResponse: success));
      }
    } on DioError catch (dioError) {
      emit(EmployeeError(dioError.response!.data['msg']));
    }
  }

  Future<void> employeeCreate(
      EmployeeCreate event, Emitter<BaseState> emit) async {
    emit(EmployeeInProgress());

    try {
      final response = await service.createEmployee(
        usuarioCreacion: event.usuarioCreacion,
        idPersona: event.idPersona,
        idSucursal: event.idSucursal,
        fechaContratacion: event.fechaContratacion,
        idPuesto: event.idPuesto,
        idStatusEmpleado: event.idStatusEmpleado,
        ingresoSueldoBase: event.ingresoSueldoBase,
        ingresoBonificacionDecreto: event.ingresoBonificacionDecreto,
        ingresoOtrosIngresos: event.ingresoOtrosIngresos,
        descuentoIgss: event.descuentoIgss,
        decuentoISR: event.decuentoISR,
        descuentoInasistencias: event.descuentoInasistencias,
      );

      if (response.statusCode == 401) {
        emit(EmployeeError(response.data['msg']));
      } else if (response.statusCode == 200) {
        emit(EmployeeCreateSuccess());
      }
    } on DioError catch (dioError) {
      emit(EmployeeError(dioError.response!.data['msg']));
    }
  }

  Future<void> employeeEdit(EmployeeEdit event, Emitter<BaseState> emit) async {
    emit(EmployeeInProgress());

    try {
      final response = await service.editEmployee(
        usuarioCreacion: event.usuarioCreacion,
        idPersona: event.idPersona,
        idSucursal: event.idSucursal,
        fechaContratacion: event.fechaContratacion,
        idPuesto: event.idPuesto,
        idStatusEmpleado: event.idStatusEmpleado,
        ingresoSueldoBase: event.ingresoSueldoBase,
        ingresoBonificacionDecreto: event.ingresoBonificacionDecreto,
        ingresoOtrosIngresos: event.ingresoOtrosIngresos,
        descuentoIgss: event.descuentoIgss,
        decuentoISR: event.decuentoISR,
        descuentoInasistencias: event.descuentoInasistencias,
        idEmpleado: event.idEmpleado,
      );

      if (response.statusCode == 401) {
        emit(EmployeeError(response.data['msg']));
      } else if (response.statusCode == 200) {
        emit(EmployeeEditSuccess());
      }
    } on DioError catch (dioError) {
      emit(EmployeeError(dioError.response!.data['msg']));
    }
  }

  Future<void> employeeDelete(
      EmployeeDelete event, Emitter<BaseState> emit) async {
    emit(EmployeeInProgress());

    try {
      final response = await service.employeeDelete(
        id: event.id,
      );

      if (response.statusCode == 401) {
        emit(EmployeeError(response.data['msg']));
      } else if (response.statusCode == 200) {
        emit(EmployeeDeleteSuccess());
      }
    } on DioError catch (dioError) {
      emit(EmployeeError(dioError.response!.data['msg']));
    }
  }
}
