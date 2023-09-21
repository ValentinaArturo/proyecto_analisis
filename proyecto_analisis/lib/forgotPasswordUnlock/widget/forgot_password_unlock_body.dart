import 'package:flutter/material.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/common/security/hash.dart';
import 'package:proyecto_analisis/common/textField/input.dart';
import 'package:proyecto_analisis/common/validation/validate_email.dart';
import 'package:proyecto_analisis/common/validation/validate_password.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';

class ForgotPasswordUnlockBody extends StatefulWidget {
  const ForgotPasswordUnlockBody({super.key});

  @override
  State<ForgotPasswordUnlockBody> createState() =>
      _ForgotPasswordUnlockBodyState();
}

class _ForgotPasswordUnlockBodyState extends State<ForgotPasswordUnlockBody>
    with ErrorHandling {
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController email = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(),
              Container(
                padding: const EdgeInsets.only(left: 35, top: 100),
                child: const Text(
                  'Cambiar contraseña',
                  style: TextStyle(color: Colors.white, fontSize: 43),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.5),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 235, right: 235),
                          child: Column(
                            children: [
                              CustomInput(
                                controller: email,
                                validator: (text) {
                                  validateEmail(
                                    text,
                                    context,
                                  );
                                },
                                label: "Correo",
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              CustomInput(
                                controller: newPassword,
                                validator: (text) {
                                  validatePassword(
                                    text,
                                    context,
                                  );
                                },
                                obscureText: true,
                                label: "Nueva contraseña",
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              CustomInput(
                                controller: confirmPassword,
                                validator: (text) {
                                  if (confirmPassword.text != password.text) {
                                    return "Las contraseñas no coinciden";
                                  }
                                },
                                obscureText: true,
                                label: "Confirmar contraseña",
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Continuar',
                                    style: TextStyle(
                                        fontSize: 27,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: const Color(0xff4c505b),
                                    child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          UserRepository userRepository =
                                              UserRepository();
                                          userRepository.setPassword(
                                            Hash.hash(confirmPassword.text),
                                          );
                                          Navigator.pushNamed(
                                            context,
                                            securityQuestionsRoute,
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
