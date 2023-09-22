import 'package:flutter/material.dart';
import 'package:proyecto_analisis/accessDenied/acess_denied_screen.dart';
import 'package:proyecto_analisis/dashboard/dashboard_screen.dart';
import 'package:proyecto_analisis/forgotPassword/forgot_password_screen.dart';
import 'package:proyecto_analisis/forgotPasswordUnlock/forgot_password_unlock_screen.dart';
import 'package:proyecto_analisis/login/login_screen.dart';
import 'package:proyecto_analisis/rol/rol_screen.dart';
import 'package:proyecto_analisis/routes/generator_route.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';
import 'package:proyecto_analisis/securityQuestions/security_questions_screen.dart';
import 'package:proyecto_analisis/signUp/sign_up_screen.dart';

class LandingRoutes {
  static Route<dynamic> generateRouteLanding(final RouteSettings settings) {
    switch (settings.name) {
      case rootRoute:
        return GeneratePageRoute(
          widget: const LoginScreen(),
          routeName: settings.name!,
        );
      case loginRoute:
        return GeneratePageRoute(
          widget: const LoginScreen(),
          routeName: settings.name!,
        );
      case signUpRoute:
        return GeneratePageRoute(
          widget: const SignUpScreen(),
          routeName: settings.name!,
        );
      case accessDeniedRoute:
        return GeneratePageRoute(
          widget: const AccessDeniedScreen(),
          routeName: settings.name!,
        );
      case forgotPasswordRoute:
        return GeneratePageRoute(
          widget: const ForgotPasswordScreen(),
          routeName: settings.name!,
        );
      case securityQuestionsRoute:
        return GeneratePageRoute(
          widget: const SecurityQuestionsScreen(),
          routeName: settings.name!,
        );
      case dashboardRoute:
        return GeneratePageRoute(
          widget: DashboardScreen(),
          routeName: settings.name!,
        );
      case forgotPasswordExpiredRoute:
        return GeneratePageRoute(
          widget: const ForgotPasswordUnlockScreen(),
          routeName: settings.name!,
        );
      case rolRoute:
        return GeneratePageRoute(
          widget: const RolScreen(),
          routeName: settings.name!,
        );
      default:
        return GeneratePageRoute(
          widget: Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          routeName: '',
        );
    }
  }
}
