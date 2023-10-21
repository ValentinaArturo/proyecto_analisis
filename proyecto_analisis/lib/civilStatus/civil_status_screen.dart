import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/civilStatus/bloc/civil_status_bloc.dart';
import 'package:proyecto_analisis/civilStatus/service/civil_status_service.dart';
import 'package:proyecto_analisis/civilStatus/widget/civil_status_body.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CivilStatusScreen extends StatefulWidget {
  const CivilStatusScreen({Key? key}) : super(key: key);

  @override
  _CivilStatusScreenState createState() => _CivilStatusScreenState();
}

class _CivilStatusScreenState extends State<CivilStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CivilStatusBloc(
        service: CivilStatusService(),
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
          desktop: (context) => const CivilStatusBody(),
          mobile: (context) => const CivilStatusBody(),
        ),
      ),
    );
  }
}
