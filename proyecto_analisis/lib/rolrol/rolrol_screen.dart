import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/rolrol/bloc/rolrol_bloc.dart';
import 'package:proyecto_analisis/rolrol/service/rolrol_service.dart';
import 'package:proyecto_analisis/rolrol/widget/rolrol_body.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RolRolScreen extends StatefulWidget {
  const RolRolScreen({Key? key}) : super(key: key);

  @override
  _RolRolScreenState createState() => _RolRolScreenState();
}

class _RolRolScreenState extends State<RolRolScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RolRolBloc(
        service: RolRolService(),
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
          desktop: (context) => const RolRolBody(),
          mobile: (context) => const RolRolBody(),
        ),
      ),
    );
  }
}
