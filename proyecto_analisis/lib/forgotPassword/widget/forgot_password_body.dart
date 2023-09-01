import 'package:flutter/material.dart';
import 'package:proyecto_analisis/common/textField/input.dart';
import 'package:proyecto_analisis/common/validation/validate_password.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            controller: password,
                            validator: (text) {
                              validatePassword(
                                text,
                                context,
                              );
                            },
                            label: "Contraseña Actual",
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
                              validatePassword(
                                text,
                                context,
                              );
                            },
                            obscureText: true,
                            label: "Confirmar contraseña",
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Verificar',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      securityQuestionsRoute,
                                    );
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
    );
  }
}
