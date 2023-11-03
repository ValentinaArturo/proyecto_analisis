part of 'payroll_report_bloc.dart';

abstract class PayrollReportEvent {}

class PayrollReport extends PayrollReportEvent {
  final int year;
  final int month;

  PayrollReport({
    required this.year,
    required this.month,
  });
}

class PayrollReportCreate extends PayrollReportEvent {
  final int year;
  final int month;

  PayrollReportCreate({
    required this.year,
    required this.month,
  });
}
