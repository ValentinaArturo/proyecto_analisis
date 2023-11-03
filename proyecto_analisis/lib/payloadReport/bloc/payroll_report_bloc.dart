import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/payloadReport/model/payroll_response.dart';
import 'package:proyecto_analisis/payloadReport/service/payroll_report_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

part 'payroll_report_event.dart';

part 'payroll_report_state.dart';

class PayrollReportBloc extends BaseBloc<PayrollReportEvent, BaseState> {
  PayrollReportBloc({
    required this.service,
    required this.userRepository,
  }) : super(PayrollReportInitial()) {
    on<PayrollReport>(payrollReport);
    on<PayrollReportCreate>(payrollReportCreate);
  }

  final PayrollReportService service;
  final UserRepository userRepository;

  Future<void> payrollReport(
    PayrollReport event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      PayrollReportInProgress(),
    );

    try {
      final response = await service.payrollReport(
        year: event.year,
        month: event.month,
      );

      if (response.statusCode == 401) {
        emit(
          PayrollReportError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = PayrollResponse.fromJson(
          response.data!,
        );
        emit(
          PayrollReportSuccess(
            cabecera: success.cabecera,
            detalle: success.detalle,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        PayrollReportError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> payrollReportCreate(
    PayrollReportCreate event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      PayrollReportInProgress(),
    );

    try {
      final response = await service.createPayrollReport(
        year: event.year,
        month: event.month,
      );

      if (response.statusCode == 401) {
        emit(
          PayrollReportError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          PayrollReportCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        PayrollReportError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
