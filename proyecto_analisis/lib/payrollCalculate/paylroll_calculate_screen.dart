import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/payloadReport/bloc/payroll_report_bloc.dart';
import 'package:proyecto_analisis/payloadReport/service/payroll_report_service.dart';
import 'package:proyecto_analisis/payloadReport/widget/payroll_report_body.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PayrollCalculateScreen extends StatefulWidget {
  const PayrollCalculateScreen({Key? key}) : super(key: key);

  @override
  _PayrollCalculateScreenState createState() => _PayrollCalculateScreenState();
}

class _PayrollCalculateScreenState extends State<PayrollCalculateScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PayrollReportBloc(
        service: PayrollReportService(),
        userRepository: UserRepository(),
      ),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/register.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: ScreenTypeLayout.builder(
          desktop: (context) => const PayrollReportBody(),
          mobile: (context) =>
          const PayrollReportBody(),
        ),
      ),
    );
  }
}
