import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/civilStatus/model/civil_status.dart';
import 'package:proyecto_analisis/civilStatus/service/civil_status_service.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

part 'civil_status_event.dart';
part 'civil_status_state.dart';

class CivilStatusBloc extends BaseBloc<CivilStatusEvent, BaseState> {
  CivilStatusBloc({
    required this.service,
    required this.userRepository,
  }) : super(CivilStatusInitial()) {
    on<GetCivilStatus>(getCivilStatus);
    on<CreateCivilStatus>(createCivilStatus);
    on<EditCivilStatus>(editCivilStatus);
    on<DeleteCivilStatus>(deleteCivilStatus);
  }

  final CivilStatusService service;
  final UserRepository userRepository;

  Future<void> getCivilStatus(
    GetCivilStatus event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      CivilStatusInProgress(),
    );

    try {
      final response = await service.getCivilStatus();

      if (response.statusCode == 401) {
        emit(
          CivilStatusError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = CivilStatusResponse.fromJson(
          response.data!,
        );
        emit(
          CivilStatusSuccess(
            success: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        CivilStatusError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> createCivilStatus(
    CreateCivilStatus event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      CivilStatusInProgress(),
    );

    try {
      final response = await service.civilStatusCreate(
        nombre: event.nombre,
        idUsuarioCreacion: event.idUsuarioCreacion,
      );

      if (response.statusCode == 401) {
        emit(
          CivilStatusError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          CivilStatusCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        CivilStatusError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> editCivilStatus(
    EditCivilStatus event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      CivilStatusInProgress(),
    );

    try {
      final response = await service.civilStatusEdit(
        nombre: event.nombre,
        idEstadoCivil: event.idCivilStatus,
        idUsuarioModificacion: event.idUsuarioModificacion,
      );

      if (response.statusCode == 401) {
        emit(
          CivilStatusError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          CivilStatusEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        CivilStatusError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> deleteCivilStatus(
    DeleteCivilStatus event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      CivilStatusInProgress(),
    );

    try {
      final response = await service.civilStatusDelete(
        idEstadoCivil: event.idCivilStatus,
      );

      if (response.statusCode == 401) {
        emit(
          CivilStatusError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          CivilStatusDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        CivilStatusError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
