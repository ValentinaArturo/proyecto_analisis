import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/person/bloc/person_bloc.dart'; // Cambiar el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/person/service/person_service.dart'; // Cambiar el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/person/widget/person_body.dart'; // Cambiar el nombre del archivo y la carpeta si es necesario
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({Key? key}) : super(key: key);

  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonBloc( // Cambiar el nombre del Bloc
        service: PersonService(), // Cambiar el nombre del servicio
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
          desktop: (context) => const PersonBody(), // Cambiar el nombre del Widget
          mobile: (context) => const PersonBody(), // Cambiar el nombre del Widget
        ),
      ),
    );
  }
}
