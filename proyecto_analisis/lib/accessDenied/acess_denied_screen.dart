import 'package:flutter/material.dart';
import 'package:proyecto_analisis/accessDenied/widget/access_denied_body.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AccessDeniedScreen extends StatefulWidget {
  const AccessDeniedScreen({Key? key}) : super(key: key);

  @override
  _AccessDeniedScreenState createState() => _AccessDeniedScreenState();
}

class _AccessDeniedScreenState extends State<AccessDeniedScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/blocked.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: ScreenTypeLayout.builder(
        desktop: (context) => const AccessDeniedBody(),
        mobile: (context) => const AccessDeniedBody(),
      ),
    );
  }
}
