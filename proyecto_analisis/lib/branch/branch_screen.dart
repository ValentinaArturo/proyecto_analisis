import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/branch/bloc/branch_bloc.dart';
import 'package:proyecto_analisis/branch/sevice/branch_service.dart';
import 'package:proyecto_analisis/branch/widget/branch_body.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BranchScreen extends StatefulWidget {
  const BranchScreen({Key? key}) : super(key: key);

  @override
  _BranchScreenState createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BranchBloc(
        service: BranchService(),
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
          desktop: (context) => const BranchBody(),
          mobile: (context) => const BranchBody(),
        ),
      ),
    );
  }
}
