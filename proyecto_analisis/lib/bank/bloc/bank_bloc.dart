import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/bank/model/bank_response.dart';
import 'package:proyecto_analisis/bank/service/bank_service.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

part 'bank_event.dart';
part 'bank_state.dart';

class BankBloc extends BaseBloc<BankEvent, BaseState> {
  BankBloc({
    required this.service,
    required this.userRepository,
  }) : super(BankInitial()) {
    on<GetBank>(getBanks);
    on<CreateBank>(createBank);
    on<EditBank>(editBank);
    on<DeleteBank>(deleteBank);
  }

  final BankService service;
  final UserRepository userRepository;

  Future<void> getBanks(
    GetBank event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      BankInProgress(),
    );

    try {
      final response = await service.getBank();

      if (response.statusCode == 401) {
        emit(
          BankError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = BankResponse.fromJson(
          response.data!,
        );
        emit(
          BankSuccess(
            success: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        BankError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> createBank(
    CreateBank event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      BankInProgress(),
    );

    try {
      final response = await service.bankCreate(
        nombre: event.nombre,
        idUsuarioCreacion: event.idUsuarioModificacion,
      );

      if (response.statusCode == 401) {
        emit(
          BankError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          BankCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        BankError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> editBank(
    EditBank event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      BankInProgress(),
    );

    try {
      final response = await service.bankEdit(
        nombre: event.nombre,
        idUsuarioModificacion: event.idUsuarioModificacion,
        idBank: event.idBank,
      );

      if (response.statusCode == 401) {
        emit(
          BankError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          BankEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        BankError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> deleteBank(
    DeleteBank event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      BankInProgress(),
    );

    try {
      final response = await service.bankDelete(
        idBank: event.idBank,
      );

      if (response.statusCode == 401) {
        emit(
          BankError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          BankDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        BankError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
