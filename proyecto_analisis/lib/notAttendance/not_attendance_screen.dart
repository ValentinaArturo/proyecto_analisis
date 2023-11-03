import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/notAttendance/bloc/not_assistance_bloc.dart';
import 'package:proyecto_analisis/notAttendance/service/not_attendance_service.dart';
import 'package:proyecto_analisis/notAttendance/widget/not_attendance_body.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:responsive_builder/responsive_builder.dart';

class NotAssistanceScreen extends StatefulWidget {
  const NotAssistanceScreen({Key? key}) : super(key: key);

  @override
  _NotAssistanceScreenState createState() => _NotAssistanceScreenState();
}

class _NotAssistanceScreenState extends State<NotAssistanceScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotAssistanceBloc(
        service: NotAttendanceService(),
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
          desktop: (context) => const NotAssistanceBody(),
          mobile: (context) => const NotAssistanceBody(),
        ),
      ),
    );
  }
}
