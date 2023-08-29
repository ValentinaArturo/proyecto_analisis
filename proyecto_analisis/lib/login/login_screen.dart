import 'package:flutter/material.dart';
import 'package:proyecto_analisis/login/widget/login_body.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/login.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: ScreenTypeLayout.builder(
        desktop: (context) => const LoginBody(),
        mobile: (context) => const LoginBody(),
      ),
    );
  }
}
