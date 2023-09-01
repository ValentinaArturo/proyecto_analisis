import 'package:flutter/material.dart';
import 'package:proyecto_analisis/forgotPassword/widget/forgot_password_body.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/forgot_password.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: ScreenTypeLayout.builder(
        desktop: (context) => const ForgotPasswordBody(),
        mobile: (context) => const ForgotPasswordBody(),
      ),
    );
  }
}
