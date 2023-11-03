import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/bank/model/bank_response.dart';
import 'package:proyecto_analisis/bankAccount/model/bank_account_response.dart';
import 'package:proyecto_analisis/bankAccount/service/bank_account_service.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/employee/model/employee.dart';
import 'package:proyecto_analisis/person/model/person.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

part 'bank_account_event.dart';
part 'bank_account_state.dart';

class BankAccountBloc extends BaseBloc<BankAccountEvent, BaseState> {
  BankAccountBloc({
    required this.service,
    required this.userRepository,
  }) : super(BankAccountInitial()) {
    on<GetBankAccount>(getBankAccounts);
    on<CreateBankAccount>(createBankAccount);
    on<EditBankAccount>(editBankAccount);
    on<DeleteBankAccount>(deleteBankAccount);
    on<Employee>(employee);
    on<Person>(person);
    on<GetBank>(getBanks);
  }

  final BankAccountService service;
  final UserRepository userRepository;

  Future<void> getBanks(
    GetBank event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      BankAccountInProgress(),
    );

    try {
      final response = await service.getBank();

      if (response.statusCode == 401) {
        emit(
          BankAccountError(
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
        BankAccountError(
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
      BankAccountInProgress(),
    );

    try {
      final response = await service.person();

      if (response.statusCode == 401) {
        emit(
          BankAccountError(
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
        BankAccountError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> employee(Employee event, Emitter<BaseState> emit) async {
    emit(BankAccountInProgress());

    try {
      final response = await service.employee();

      if (response.statusCode == 401) {
        emit(BankAccountError(response.data['msg']));
      } else if (response.statusCode == 200) {
        final success = EmployeeResponse.fromJson(response.data!);
        emit(EmployeeSuccess(employeeResponse: success));
      }
    } on DioError catch (dioError) {
      emit(BankAccountError(dioError.response!.data['msg']));
    }
  }

  Future<void> getBankAccounts(
    GetBankAccount event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      BankAccountInProgress(),
    );

    try {
      final response = await service.getBankAccount();

      if (response.statusCode == 401) {
        emit(
          BankAccountError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = BankAccountResponse.fromJson(
          response.data!,
        );
        emit(
          BankAccountSuccess(
            success: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        BankAccountError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> createBankAccount(
    CreateBankAccount event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      BankAccountInProgress(),
    );

    try {
      final response = await service.bankAccountCreate(
        idEmpleado: event.idEmpleado,
        usuarioCreacion: event.usuarioCreacion,
        activa: event.activa,
        idBanco: event.idBanco,
        numeroDeCuenta: event.numeroDeCuenta,
      );

      if (response.statusCode == 401) {
        emit(
          BankAccountError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          BankAccountCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        BankAccountError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> editBankAccount(
    EditBankAccount event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      BankAccountInProgress(),
    );

    try {
      final response = await service.bankAccountEdit(
        idEmpleado: event.idEmpleado,
        usuarioCreacion: event.usuarioCreacion,
        activa: event.activa,
        idBanco: event.idBanco,
        numeroDeCuenta: event.numeroDeCuenta,
        idCuentaBancaria: event.idCuentaBancaria,
      );

      if (response.statusCode == 401) {
        emit(
          BankAccountError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          BankAccountEditSuccess(
            response.data['msg'],
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        BankAccountError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> deleteBankAccount(
    DeleteBankAccount event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      BankAccountInProgress(),
    );

    try {
      final response = await service.bankAccountDelete(
        idBankAccount: event.idBankAccount,
      );

      if (response.statusCode == 401) {
        emit(
          BankAccountError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          BankAccountDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        BankAccountError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
