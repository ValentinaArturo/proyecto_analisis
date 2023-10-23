import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/position/bloc/position_bloc.dart'; // Cambiar el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/position/service/position_service.dart'; // Cambiar el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/position/widget/position_body.dart'; // Cambiar el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PositionScreen extends StatefulWidget {
  const PositionScreen({Key? key}) : super(key: key);

  @override
  _PositionScreenState createState() => _PositionScreenState();
}

class _PositionScreenState extends State<PositionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PositionBloc(
        // Cambiar el nombre del Bloc
        service: PositionService(), // Cambiar el nombre del servicio
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
          desktop: (context) => const PositionBody(),
          // Cambiar el nombre del Widget
          mobile: (context) =>
              const PositionBody(), // Cambiar el nombre del Widget
        ),
      ),
    );
  }
}
