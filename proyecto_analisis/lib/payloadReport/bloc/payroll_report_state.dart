part of 'payroll_report_bloc.dart';

abstract class PayrollReportState extends BaseState {}

class PayrollReportInitial extends PayrollReportState {}

class PayrollReportInProgress extends PayrollReportState {}

class PayrollReportSuccess extends PayrollReportState {
  final List<Cabecera> cabecera;
  final List<Detalle> detalle;

  PayrollReportSuccess({
    required this.cabecera,
    required this.detalle,
  });
}

class PayrollReportCreateSuccess extends PayrollReportState {}

class PayrollReportError extends PayrollReportState {
  final String? error;

  PayrollReportError(
    this.error,
  );
}
