import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/rols/bloc/rols_bloc.dart';
import 'package:proyecto_analisis/rols/service/rols_service.dart';
import 'package:proyecto_analisis/rols/widget/rols_body.dart';
import 'package:proyecto_analisis/rolsUser/widget/rols_user_body.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RolsUserScreen extends StatefulWidget {
  const RolsUserScreen({Key? key}) : super(key: key);

  @override
  _RolsUserScreenState createState() => _RolsUserScreenState();
}

class _RolsUserScreenState extends State<RolsUserScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RolsBloc(
        service: RolsService(),
        userRepository: UserRepository(),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black12,
              Colors.black26,
            ],
          ),
        ),
        child: ScreenTypeLayout.builder(
          desktop: (context) => const RolsUserBody(),
          mobile: (context) => const RolsUserBody(),
        ),
      ),
    );
  }
}
