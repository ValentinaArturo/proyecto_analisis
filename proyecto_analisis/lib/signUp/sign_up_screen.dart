import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/signUp/bloc/sign_up_bloc.dart';
import 'package:proyecto_analisis/signUp/service/sign_up_service.dart';
import 'package:proyecto_analisis/signUp/widget/sign_up_body.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignUpScreen extends StatefulWidget {
  final bool isSignUp;

  const SignUpScreen({
    Key? key,
    required this.isSignUp,
  }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(
        service: SignUpService(),
        repository: UserRepository(),
      ),
      child: Container(
        decoration: widget.isSignUp
            ? const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/register.png'),
                  fit: BoxFit.fill,
                ),
              )
            : const BoxDecoration(
                color: secondaryColor,
              ),
        child: ScreenTypeLayout.builder(
          desktop: (context) => SignUpBody(
            isSignUp: widget.isSignUp,
          ),
          mobile: (context) => SignUpBody(
            isSignUp: widget.isSignUp,
          ),
        ),
      ),
    );
  }
}
