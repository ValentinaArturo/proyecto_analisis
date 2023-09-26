import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/userDetail/bloc/user_detail_bloc.dart';
import 'package:proyecto_analisis/userDetail/service/user_detail_service.dart';
import 'package:proyecto_analisis/userDetail/widget/user_detail_body.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDetailBloc(
        service: UserDetailService(),
        repository: UserRepository(),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: ScreenTypeLayout.builder(
          desktop: (context) => const UserDetailBody(),
          mobile: (context) => const UserDetailBody(),
        ),
      ),
    );
  }
}
