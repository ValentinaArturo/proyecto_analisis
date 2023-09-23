import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_analisis/common/components/side_menu.dart';
import 'package:proyecto_analisis/common/responsive.dart';
import 'package:proyecto_analisis/dashboard/widget/dashboard_body.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/rol/model/menu.dart';

class DashboardScreen extends StatelessWidget {
  final Menu menu;

  const DashboardScreen({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      child: DashboardBody(
        menu: menu,
      ),
    );
  }
}
