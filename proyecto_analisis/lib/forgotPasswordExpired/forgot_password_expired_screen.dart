import 'package:flutter/material.dart';
import 'package:proyecto_analisis/forgotPassword/widget/forgot_password_body.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ForgotPasswordExpiredScreen extends StatefulWidget {
  const ForgotPasswordExpiredScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordExpiredScreenState createState() => _ForgotPasswordExpiredScreenState();
}

class _ForgotPasswordExpiredScreenState extends State<ForgotPasswordExpiredScreen> {
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
