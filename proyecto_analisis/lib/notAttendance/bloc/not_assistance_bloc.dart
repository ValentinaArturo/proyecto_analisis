import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/employee/model/employee.dart';
import 'package:proyecto_analisis/notAttendance/model/not_attendance_response.dart';
import 'package:proyecto_analisis/notAttendance/service/not_attendance_service.dart';
import 'package:proyecto_analisis/person/model/person.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

part 'not_assistance_event.dart';
part 'not_assistance_state.dart';

class NotAssistanceBloc extends BaseBloc<NotAssistanceEvent, BaseState> {
  NotAssistanceBloc({
    required this.service,
    required this.userRepository,
  }) : super(NotAssistanceInitial()) {
    on<GetNotAssistance>(getNotAssistances);
    on<CreateNotAssistance>(createNotAssistance);
    on<EditNotAssistance>(editNotAssistance);
    on<DeleteNotAssistance>(deleteNotAssistance);
    on<Employee>(employee);
    on<Person>(person);
  }

  final NotAttendanceService service;
  final UserRepository userRepository;

  Future<void> person(
    Person event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      NotAssistanceInProgress(),
    );

    try {
      final response = await service.person();

      if (response.statusCode == 401) {
        emit(
          NotAssistanceError(
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
        NotAssistanceError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> employee(Employee event, Emitter<BaseState> emit) async {
    emit(NotAssistanceInProgress());

    try {
      final response = await service.employee();

      if (response.statusCode == 401) {
        emit(NotAssistanceError(response.data['msg']));
      } else if (response.statusCode == 200) {
        final success = EmployeeResponse.fromJson(response.data!);
        emit(EmployeeSuccess(employeeResponse: success));
      }
    } on DioError catch (dioError) {
      emit(NotAssistanceError(dioError.response!.data['msg']));
    }
  }

  Future<void> getNotAssistances(
    GetNotAssistance event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      NotAssistanceInProgress(),
    );

    try {
      final response = await service.getNotAttendance();

      if (response.statusCode == 401) {
        emit(
          NotAssistanceError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = NotAssistanceResponse.fromJson(
          response.data!,
        );
        emit(
          NotAssistanceSuccess(
            success: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        NotAssistanceError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> createNotAssistance(
    CreateNotAssistance event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      NotAssistanceInProgress(),
    );

    try {
      final response = await service.notAttendanceCreate(
        fechaFinal: event.fechaFinal,
        fechaInicial: event.fechaInicial,
        fechaProcesado: event.fechaProcesado,
        idEmpleado: event.idEmpleado,
        motivoInasistencia: event.motivoInasistencia,
      );

      if (response.statusCode == 401) {
        emit(
          NotAssistanceError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          NotAssistanceCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        NotAssistanceError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> editNotAssistance(
    EditNotAssistance event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      NotAssistanceInProgress(),
    );

    try {
      final response = await service.notAttendanceEdit(
        fechaFinal: event.fechaFinal,
        fechaInicial: event.fechaInicial,
        fechaProcesado: event.fechaProcesado,
        idEmpleado: event.idEmpleado,
        motivoInasistencia: event.motivoInasistencia,
        idInasistencia: event.idInasistencia,
      );

      if (response.statusCode == 401) {
        emit(
          NotAssistanceError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          NotAssistanceEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        NotAssistanceError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> deleteNotAssistance(
    DeleteNotAssistance event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      NotAssistanceInProgress(),
    );

    try {
      final response = await service.notAttendanceDelete(
        idNotAttendance: event.idNotAssistance,
      );

      if (response.statusCode == 401) {
        emit(
          NotAssistanceError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          NotAssistanceDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        NotAssistanceError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
