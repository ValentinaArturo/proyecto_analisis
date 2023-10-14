import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/common/loader/loader.dart';
import 'package:proyecto_analisis/common/textField/input.dart';
import 'package:proyecto_analisis/common/validation/validate_email.dart';
import 'package:proyecto_analisis/login/bloc/login_bloc.dart';
import 'package:proyecto_analisis/login/bloc/login_event.dart';
import 'package:proyecto_analisis/login/bloc/login_state.dart';
import 'package:proyecto_analisis/login/model/password.dart';
import 'package:proyecto_analisis/login/model/translate_password.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';
import 'package:supercharged/supercharged.dart';

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
  late Password _password;
  final GlobalKey<FlutterPwValidatorState> validatorKey =
      GlobalKey<FlutterPwValidatorState>();
  late bool passwordValid;
  late bool passwordPolicy;

  @override
  void initState() {
    super.initState();
    createBox();
    _passwordVisible = false;
    context.read<LoginBloc>().add(PolicyEm());
      passwordValid = false;
    passwordPolicy = false;
    _password = Password(
      mayus: 0,
      min: 0,
      especial: 0,
      numbers: 0,
      lenght: 0,
    );
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
      passwordValid = true;
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
      listener: (context, state) async {
        verifyServerError(state);
        if (state is LoginSuccess) {
          login();
          Navigator.pushNamed(
            context,
            rolRoute,
          );
        } else if (state is LoginError) {
          if (state.error == '401') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error!,
                ),
              ),
            );
          } else if (state.error == '402') {
            //Bloqueado por credenciales invalidas
            Navigator.pushNamed(
              context,
              accessDeniedRoute,
            );
          } else if (state.error == '33') {
            //Expirado
            Navigator.pushNamed(
              context,
              forgotPasswordRoute,
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
        } else if (state is PolicySuccess) {
          setState(() {
            _password = Password(
              mayus: state.policyResponse.policies[0].passwordCantidadMayusculas
                  .toInt()!,
              min: state.policyResponse.policies[0].passwordCantidadMinusculas
                  .toInt()!,
              especial: state.policyResponse.policies[0]
                  .passwordCantidadCaracteresEspeciales
                  .toInt()!,
              numbers: state.policyResponse.policies[0].passwordCantidadNumeros
                  .toInt()!,
              lenght: state.policyResponse.policies[0].passwordLargo.toInt()!,
            );
          });
          final UserRepository userRepository = UserRepository();
          await userRepository.setPasswordPolicy(
              state.policyResponse.policies[0].passwordCantidadMayusculas +
                  state.policyResponse.policies[0].passwordCantidadMinusculas +
                  state.policyResponse.policies[0]
                      .passwordCantidadCaracteresEspeciales +
                  state.policyResponse.policies[0].passwordCantidadNumeros +
                  state.policyResponse.policies[0].passwordLargo);
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
                                    return validateEmail(
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
                                  controller: password,
                                  onChanged: (text) {
                                    setState(() {
                                      passwordPolicy = true;
                                    });
                                  },
                                  label: "Contraseña",
                                  obscureText: !_passwordVisible,
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
                                !passwordPolicy
                                    ? Container()
                                    : Container(
                                        alignment: Alignment.topLeft,
                                        child: FlutterPwValidator(
                                          strings: TranslatePassword(),
                                          controller: password,
                                          key: validatorKey,
                                          minLength: _password.lenght,
                                          uppercaseCharCount: _password.mayus,
                                          lowercaseCharCount: _password.min,
                                          numericCharCount: _password.numbers,
                                          specialCharCount: _password.especial,
                                          width: 300,
                                          height: 150,
                                          onSuccess: () {
                                            setState(() {
                                              passwordValid = true;
                                            });
                                          },
                                          onFail: () {
                                            setState(() {
                                              passwordValid = false;
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
                                          if (_formKey.currentState!
                                                  .validate() &&
                                              passwordValid) {
                                            UserRepository repository =
                                                UserRepository();
                                            repository.setEmail(email.text);
                                            bloc.add(
                                              LoginWithEmailPassword(
                                                email: email.text,
                                                password: password.text,
                                              ),
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
                                          arguments: true,
                                        );
                                      },
                                      style: const ButtonStyle(),
                                      child: const Text(
                                        'Registro',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Color(0xff4c505b),
                                            fontSize: 18),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            forgotPasswordExpiredRoute,
                                          );
                                        },
                                        child: const Text(
                                          'Recuperar contraseña',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Color(0xff4c505b),
                                            fontSize: 18,
                                          ),
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 40,
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
