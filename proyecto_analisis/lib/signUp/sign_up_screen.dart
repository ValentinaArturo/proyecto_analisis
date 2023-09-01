import 'package:flutter/material.dart';
import 'package:proyecto_analisis/signUp/widget/sign_up_body.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/register.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: ScreenTypeLayout.builder(
        desktop: (context) => const SignUpBody(),
        mobile: (context) => const SignUpBody(),
      ),
    );
  }
}
