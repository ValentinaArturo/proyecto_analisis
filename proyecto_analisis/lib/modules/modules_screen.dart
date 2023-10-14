import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/modules/bloc/modules_bloc.dart';
import 'package:proyecto_analisis/modules/service/modules_service.dart';
import 'package:proyecto_analisis/modules/widget/modules_body.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({Key? key}) : super(key: key);

  @override
  _ModulesScreenState createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ModulesBloc(
        service: ModulesService(),
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
          desktop: (context) => const ModulesBody(),
          mobile: (context) => const ModulesBody(),
        ),
      ),
    );
  }
}
