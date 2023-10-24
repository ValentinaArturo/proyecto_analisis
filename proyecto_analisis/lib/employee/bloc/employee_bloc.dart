import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:proyecto_analisis/branch/model/branch.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/employee/model/employee.dart';
import 'package:proyecto_analisis/employee/service/employee_service.dart';
import 'package:proyecto_analisis/person/model/person.dart';
import 'package:proyecto_analisis/position/model/position.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/status/model/status.dart';

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
    on<Person>(person);
    on<Position>(position);
    on<Branch>(branch);
    on<Status>(status);
  }

  final EmployeeService service;
  final UserRepository userRepository;

  Future<void> branch(
    Branch event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      EmployeeInProgress(),
    );

    try {
      final response = await service.branch();

      if (response.statusCode == 401) {
        emit(
          EmployeeError(
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
        EmployeeError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> position(
    Position event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      EmployeeInProgress(),
    );

    try {
      final response = await service.position();

      if (response.statusCode == 401) {
        emit(
          EmployeeError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = PositionResponse.fromJson(
          response.data!,
        );
        emit(
          PositionSuccess(
            positionResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        EmployeeError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> status(
    Status event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      EmployeeInProgress(),
    );

    try {
      final response = await service.status();

      if (response.statusCode == 401) {
        emit(
          EmployeeError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = StatusResponse.fromJson(
          response.data!,
        );
        emit(
          StatusSuccess(
            statusResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        EmployeeError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> person(
    Person event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      EmployeeInProgress(),
    );

    try {
      final response = await service.person();

      if (response.statusCode == 401) {
        emit(
          EmployeeError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = PersonResponse.fromJson(
          response.data!,
        );
        emit(
          PersonSuccess(
            personResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        EmployeeError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

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
