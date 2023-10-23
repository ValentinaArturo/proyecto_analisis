import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/status/bloc/status_bloc.dart'; // Cambiar el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/status/service/status_service.dart'; // Cambiar el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/status/widget/status_body.dart'; // Cambiar el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:responsive_builder/responsive_builder.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatusBloc(
        // Cambiar el nombre del Bloc
        service: StatusService(), // Cambiar el nombre del servicio
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
          desktop: (context) => const StatusBody(),
          // Cambiar el nombre del Widget
          mobile: (context) =>
          const StatusBody(), // Cambiar el nombre del Widget
        ),
      ),
    );
  }
}
