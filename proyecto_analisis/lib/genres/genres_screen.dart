import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/genres/bloc/genres_bloc.dart';
import 'package:proyecto_analisis/genres/service/genres_service.dart';
import 'package:proyecto_analisis/genres/widget/genres_body.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:responsive_builder/responsive_builder.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);

  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GenresBloc(
        service: GenresService(),
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
          desktop: (context) => const GenresBody(),
          mobile: (context) => const GenresBody(),
        ),
      ),
    );
  }
}
