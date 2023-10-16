import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/company/bloc/company_event.dart';
import 'package:proyecto_analisis/company/bloc/company_state.dart';
import 'package:proyecto_analisis/company/model/company.dart' as model;
import 'package:proyecto_analisis/company/service/company_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

class CompanyBloc extends BaseBloc<CompanyEvent, BaseState> {
  CompanyBloc({
    required this.service,
    required this.userRepository,
  }) : super(CompanyInitial()) {
    on<Company>(company);
    on<CompanyEdit>(companyEdit);
    on<CompanyDelete>(companyDelete);
    on<CompanyCreate>(companyCreate);
  }

  final CompanyService service;
  final UserRepository userRepository;

  Future<void> company(
    Company event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      CompanyInProgress(),
    );

    try {
      final response = await service.company();

      if (response.statusCode == 401) {
        emit(
          CompanyError(
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
        CompanyError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> companyCreate(
    CompanyCreate event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      CompanyInProgress(),
    );

    try {
      final response = await service.companyCreate(
        name: event.name,
        userCreate: event.nameCreate,
        nit: event.nit,
        passwordCantidadMayusculas: event.passwordCantidadMayusculas,
        passwordCantidadMinusculas: event.passwordCantidadMinusculas,
        passwordCantidadCaracteresEspeciales:
            event.passwordCantidadCaracteresEspeciales,
        passwordCantidadCaducidadDias: event.passwordCantidadCaducidadDias,
        passwordLargo: event.passwordLargo,
        passwordIntentosAntesDeBloquear: event.passwordIntentosAntesDeBloquear,
        passwordCantidadPreguntasValidar:
            event.passwordCantidadPreguntasValidar,
        passwordCantidadNumeros: event.passwordCantidadNumeros,
        direccion: event.direccion,
      );

      if (response.statusCode == 401) {
        emit(
          CompanyError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          CompanyCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        CompanyError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> companyEdit(
    CompanyEdit event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      CompanyInProgress(),
    );

    try {
      final response = await service.companyEdit(
        name: event.name,
        userCreate: event.nameCreate,
        nit: event.nit,
        passwordCantidadMayusculas: event.passwordCantidadMayusculas,
        passwordCantidadMinusculas: event.passwordCantidadMinusculas,
        passwordCantidadCaracteresEspeciales:
            event.passwordCantidadCaracteresEspeciales,
        passwordCantidadCaducidadDias: event.passwordCantidadCaducidadDias,
        passwordLargo: event.passwordLargo,
        passwordIntentosAntesDeBloquear: event.passwordIntentosAntesDeBloquear,
        passwordCantidadPreguntasValidar:
            event.passwordCantidadPreguntasValidar,
        passwordCantidadNumeros: event.passwordCantidadNumeros,
        direccion: event.direccion,
      );

      if (response.statusCode == 401) {
        emit(
          CompanyError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          CompanyEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        CompanyError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> companyDelete(
    CompanyDelete event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      CompanyInProgress(),
    );

    try {
      final response = await service.companyDelete(
        id: event.id,
      );

      if (response.statusCode == 401) {
        emit(
          CompanyError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          CompanyDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        CompanyError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
