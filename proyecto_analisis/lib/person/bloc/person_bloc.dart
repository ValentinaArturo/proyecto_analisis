import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/person/model/person.dart';
import 'package:proyecto_analisis/person/service/person_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends BaseBloc<PersonEvent, BaseState> {
  // Cambiado de 'MenuBloc' a 'PersonBloc'
  PersonBloc({
    required this.service,
    required this.userRepository,
  }) : super(PersonInitial()) {
    on<Person>(person);
    on<PersonCreate>(personCreate);
    on<PersonEdit>(personEdit);
    on<PersonDelete>(personDelete);
  }

  final PersonService service;
  final UserRepository userRepository;

  Future<void> person(
    Person event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      PersonInProgress(),
    );

    try {
      final response = await service.person();

      if (response.statusCode == 401) {
        emit(
          PersonError(
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
        PersonError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> personCreate(
    PersonCreate event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      PersonInProgress(),
    );

    try {
      final response = await service.createPerson(
        nombre: event.nombre,
        apellido: event.apellido,
        fechaNacimiento: event.fechaNacimiento,
        correoElectronico: event.correoElectronico,
        telefono: event.telefono,
        idGenero: event.idGenero,
        direccion: event.direccion,
        idEstadoCivil: event.idEstadoCivil,
        usuarioCreacion: event.usuarioCreacion,
      );

      if (response.statusCode == 401) {
        emit(
          PersonError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          PersonCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        PersonError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> personEdit(
    PersonEdit event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      PersonInProgress(),
    );

    try {
      final response = await service.editPerson(
        nombre: event.nombre,
        apellido: event.apellido,
        fechaNacimiento: event.fechaNacimiento,
        idGenero: event.idGenero,
        direccion: event.direccion,
        telefono: event.telefono,
        correoElectronico: event.correoElectronico,
        idEstadoCivil: event.idEstadoCivil,
        usuarioModificacion: event.usuarioModificacion,
        idPersona: event.id,
      );

      if (response.statusCode == 401) {
        emit(
          PersonError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          PersonEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        PersonError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> personDelete(
    PersonDelete event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      PersonInProgress(),
    );

    try {
      final response = await service.personDelete(
        id: event.id,
      );

      if (response.statusCode == 401) {
        emit(
          PersonError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          PersonDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        PersonError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
