import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/common/loader/loader.dart';
import 'package:proyecto_analisis/common/textField/input.dart';
import 'package:proyecto_analisis/common/validation/validate_password.dart';
import 'package:proyecto_analisis/forgotPassword/bloc/forgot_password_bloc.dart';
import 'package:proyecto_analisis/forgotPassword/bloc/forgot_password_event.dart';
import 'package:proyecto_analisis/forgotPassword/bloc/forgot_password_state.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody>
    with ErrorHandling {
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController email = TextEditingController();

  late ForgotPasswordBloc bloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<ForgotPasswordBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is ForgotPasswordSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            loginRoute,
            (route) => false,
          );
        } else if (state is ForgotPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error!,
              ),
            ),
          );
        }
      },
      child: Stack(
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
                            margin:
                                const EdgeInsets.only(left: 235, right: 235),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
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
                                      'Verificar',
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
                                          bloc.add(
                                            ForgotPassword(
                                              newPassword: newPassword.text,
                                              oldPassword: password.text,
                                            ),
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
          ),
          BlocBuilder<ForgotPasswordBloc, BaseState>(
            builder: (context, state) {
              if (state is ForgotPasswordInProgress) {
                return const Loader();
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
