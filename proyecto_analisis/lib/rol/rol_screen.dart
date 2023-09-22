import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/rol/widget/rol_body.dart';
import 'package:proyecto_analisis/signUp/bloc/sign_up_bloc.dart';
import 'package:proyecto_analisis/signUp/service/sign_up_service.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RolScreen extends StatefulWidget {
  const RolScreen({Key? key}) : super(key: key);

  @override
  _RolScreenState createState() => _RolScreenState();
}

class _RolScreenState extends State<RolScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(
        service: SignUpService(),
        repository: UserRepository(),
      ),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/register.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: ScreenTypeLayout.builder(
          desktop: (context) => const RolBody(),
          mobile: (context) => const RolBody(),
        ),
      ),
    );
  }
}
