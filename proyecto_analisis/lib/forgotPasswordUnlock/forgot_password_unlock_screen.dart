import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/forgotPasswordUnlock/bloc/forgot_password_unlock_bloc.dart';
import 'package:proyecto_analisis/forgotPasswordUnlock/service/forgot_password_unlock_service.dart';
import 'package:proyecto_analisis/forgotPasswordUnlock/widget/forgot_password_unlock_body.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ForgotPasswordUnlockScreen extends StatefulWidget {
  const ForgotPasswordUnlockScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordUnlockScreenState createState() => _ForgotPasswordUnlockScreenState();
}

class _ForgotPasswordUnlockScreenState extends State<ForgotPasswordUnlockScreen> {
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
        desktop: (context) => const ForgotPasswordUnlockBody(),
        mobile: (context) => const ForgotPasswordUnlockBody(),
      ),
    );
  }
}
