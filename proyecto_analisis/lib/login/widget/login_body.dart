import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/common/loader/loader.dart';
import 'package:proyecto_analisis/common/textField/input.dart';
import 'package:proyecto_analisis/common/validation/validate_email.dart';
import 'package:proyecto_analisis/common/validation/validate_password.dart';
import 'package:proyecto_analisis/login/bloc/login_bloc.dart';
import 'package:proyecto_analisis/login/bloc/login_event.dart';
import 'package:proyecto_analisis/login/bloc/login_state.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> with ErrorHandling {
  bool isChecked = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late Box box1;
  late LoginBloc bloc;
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    createBox();
    _passwordVisible = false;
  }

  void createBox() async {
    box1 = await Hive.openBox('logininfo');
    getdata();
  }

  void getdata() async {
    if (box1.get('email') != null) {
      email.text = box1.get('email');
      isChecked = true;
      setState(() {});
    }
    if (box1.get('password') != null) {
      password.text = box1.get('password');
      isChecked = true;
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<LoginBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is LoginSuccess) {
          login();
          Navigator.pushNamed(
            context,
            dashboardRoute,
          );
        } else if (state is LoginError) {
          if (state.error == '403') {
            Navigator.pushNamed(
              context,
              accessDeniedRoute,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error!,
                ),
              ),
            );
          }
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
                    'Bienvenido',
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
                                  validator: (text) {
                                    validatePassword(
                                      text,
                                      context,
                                    );
                                  },
                                  controller: password,
                                  label: "Contraseña",
                                  obscureText: true,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Recuerdame",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Checkbox(
                                      value: isChecked,
                                      onChanged: (value) {
                                        isChecked = !isChecked;
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Iniciar Sesion',
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
                                            LoginWithEmailPassword(
                                              email: email.text,
                                              password: password.text,
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
                                const SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          signUpRoute,
                                        );
                                      },
                                      style: const ButtonStyle(),
                                      child: const Text(
                                        'Sign Up',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Color(0xff4c505b),
                                            fontSize: 18),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          'Forgot Password',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Color(0xff4c505b),
                                            fontSize: 18,
                                          ),
                                        )),
                                  ],
                                )
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
          BlocBuilder<LoginBloc, BaseState>(
            builder: (context, state) {
              if (state is LoginInProgress) {
                return const Loader();
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  void login() {
    if (isChecked) {
      box1.put('email', email.text);
      box1.put('password', password.text);
    }
  }
}
