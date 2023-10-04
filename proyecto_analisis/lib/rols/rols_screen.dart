import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/rols/bloc/rols_bloc.dart';
import 'package:proyecto_analisis/rols/service/rols_service.dart';
import 'package:proyecto_analisis/rols/widget/rols_body.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RolsScreen extends StatefulWidget {
  const RolsScreen({Key? key}) : super(key: key);

  @override
  _RolsScreenState createState() => _RolsScreenState();
}

class _RolsScreenState extends State<RolsScreen> {
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
          desktop: (context) => const RolsBody(),
          mobile: (context) => const RolsBody(),
        ),
      ),
    );
  }
}
