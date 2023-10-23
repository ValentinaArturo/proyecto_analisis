import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/employee/bloc/employee_bloc.dart'; // Cambiado el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/employee/service/employee_service.dart'; // Cambiado el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/employee/widget/employee_body.dart'; // Cambiado el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc( // Cambiado el nombre del Bloc
        service: EmployeeService(), // Cambiado el nombre del servicio
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
          desktop: (context) => const EmployeeBody(), // Cambiado el nombre del Widget
          mobile: (context) => const EmployeeBody(), // Cambiado el nombre del Widget
        ),
      ),
    );
  }
}
