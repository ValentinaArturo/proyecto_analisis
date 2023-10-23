import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/department/bloc/department_bloc.dart'; // Cambiar el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/department/service/department_service.dart'; // Cambiar el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/department/widget/department_body.dart'; // Cambiar el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({Key? key}) : super(key: key);

  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DepartmentBloc(
        // Cambiar el nombre del Bloc
        service: DepartmentService(), // Cambiar el nombre del servicio
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
          desktop: (context) => const DepartmentBody(),
          // Cambiar el nombre del Widget
          mobile: (context) =>
          const DepartmentBody(), // Cambiar el nombre del Widget
        ),
      ),
    );
  }
}
