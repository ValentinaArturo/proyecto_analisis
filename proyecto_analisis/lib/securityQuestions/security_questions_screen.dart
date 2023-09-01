import 'package:flutter/material.dart';
import 'package:proyecto_analisis/securityQuestions/widget/security_questions_body.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SecurityQuestionsScreen extends StatefulWidget {
  const SecurityQuestionsScreen({Key? key}) : super(key: key);

  @override
  _SecurityQuestionsScreenState createState() =>
      _SecurityQuestionsScreenState();
}

class _SecurityQuestionsScreenState extends State<SecurityQuestionsScreen> {
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
        desktop: (context) => const SecurityQuestionsBody(),
        mobile: (context) => const SecurityQuestionsBody(),
      ),
    );
  }
}
