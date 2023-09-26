import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/common/textField/input.dart';
import 'package:proyecto_analisis/common/validation/validate_email.dart';
import 'package:proyecto_analisis/login/model/password.dart';
import 'package:proyecto_analisis/login/model/translate_password.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';
import 'package:proyecto_analisis/signUp/model/genre.dart';
import 'package:proyecto_analisis/userDetail/bloc/user_detail_bloc.dart';
import 'package:proyecto_analisis/userDetail/bloc/user_detail_event.dart';
import 'package:proyecto_analisis/userDetail/bloc/user_detail_state.dart';

import '../../common/loader/loader.dart';

class UserDetailBody extends StatefulWidget {
  const UserDetailBody({Key? key}) : super(key: key);

  @override
  State<UserDetailBody> createState() => _UserDetailBodyState();
}

class _UserDetailBodyState extends State<UserDetailBody> with ErrorHandling {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstQuestion = TextEditingController();
  TextEditingController secondQuestion = TextEditingController();
  TextEditingController thirdQuestion = TextEditingController();
  late bool _passwordVisible;
  int? gender;
  List<GenreItem> genres = [];
  late UserDetailBloc bloc;
  late final String firstQuestionSentence;
  late final String secondQuestionSentence;
  late final String thirdQuestionSentence;
  late Password _password;
  final GlobalKey<FlutterPwValidatorState> validatorKey =
      GlobalKey<FlutterPwValidatorState>();
  late bool passwordValid;
  late bool passwordPolicy;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    gender = 0;
    firstQuestionSentence = '¿En qué ciudad naciste?';
    secondQuestionSentence = '¿Cuál es el segundo nombre de tu madre?';
    thirdQuestionSentence = '¿Cuál fue tu primer trabajo?';
    context.read<UserDetailBloc>().add(
          Genre(),
        );
    passwordValid = false;
    passwordPolicy = false;
    _password = Password(
      mayus: 0,
      min: 0,
      especial: 0,
      numbers: 0,
      lenght: 0,
    );
    _getPasswordPolicy();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<UserDetailBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDetailBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is UserDetailSuccess) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(state.successResponse.msg),
                  content: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        loginRoute,
                      );
                    },
                    child: Text('Aceptar'),
                  ),
                );
              });
        } else if (state is GenreSuccess) {
          setState(() {
            genres = state.genreResponse.genres;
          });
        } else if (state is UserDetailError) {
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
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 35, top: 30),
                  child: const Text(
                    'Editar\nUsuario',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.28),
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
                                  label: "Nombre",
                                  controller: name,
                                  isSignUp: true,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomInput(
                                  label: "Apellido",
                                  controller: lastName,
                                  isSignUp: true,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomInput(
                                  label: "Fecha de nacimiento     AAAA-MM-DD",
                                  controller: birthDate,
                                  isSignUp: true,
                                  inputFormatters: [
                                    MaskTextInputFormatter(mask: '####-##-##'),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomInput(
                                  label: "Telefono",
                                  controller: phone,
                                  isSignUp: true,
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                      mask: '####-####',
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomRadioButton(
                                  elevation: 0,
                                  width: 200,
                                  absoluteZeroSpacing: false,
                                  unSelectedColor:
                                      Colors.deepOrange.withOpacity(0.4),
                                  buttonLables:
                                      genres.map((g) => g.genero).toList(),
                                  buttonValues:
                                      genres.map((g) => g.idGenero).toList(),
                                  buttonTextStyle: const ButtonTextStyle(
                                    selectedColor: Colors.orange,
                                    unSelectedColor: Colors.white,
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  radioButtonValue: (value) {
                                    print(value);
                                  },
                                  selectedColor: Colors.white,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomInput(
                                  label: "Correo",
                                  controller: email,
                                  isSignUp: true,
                                  validator: (text) {
                                    return validateEmail(
                                      text,
                                      context,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomInput(
                                  obscureText: !_passwordVisible,
                                  label: "Contraseña",
                                  onChanged: (text) {
                                    setState(() {
                                      passwordPolicy = true;
                                    });
                                  },
                                  controller: password,
                                  isSignUp: true,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
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
                                CustomInput(
                                  controller: firstQuestion,
                                  label: "1. $firstQuestionSentence",
                                  isSignUp: true,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomInput(
                                  controller: secondQuestion,
                                  label: "2. $secondQuestionSentence",
                                  isSignUp: true,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomInput(
                                  controller: thirdQuestion,
                                  label: "3. $thirdQuestionSentence",
                                  isSignUp: true,
                                ),
                                const SizedBox(
                                  height: 40,
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
                                        if (_formKey.currentState!.validate() &&
                                            passwordValid) {
                                          bloc.add(
                                            UserDetail(
                                              email: email.text,
                                              password: password.text,
                                              name: name.text,
                                              lastName: lastName.text,
                                              genre: gender!,
                                              birthDate: birthDate.text,
                                              phone: phone.text,
                                              id1: firstQuestionSentence,
                                              id2: secondQuestionSentence,
                                              id3: thirdQuestionSentence,
                                              q1: firstQuestion.text
                                                  .toLowerCase()
                                                  .replaceAll(' ', ''),
                                              q2: secondQuestion.text
                                                  .toLowerCase()
                                                  .replaceAll(' ', ''),
                                              q3: thirdQuestion.text
                                                  .toLowerCase()
                                                  .replaceAll(' ', ''),
                                            ),
                                          );
                                        }
                                      },
                                      style: const ButtonStyle(),
                                      child: const Text(
                                        'Registrar',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
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
          BlocBuilder<UserDetailBloc, BaseState>(
            builder: (context, state) {
              if (state is UserDetailInProgress) {
                return const Loader();
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  _getPasswordPolicy() async {
    final UserRepository userRepository = UserRepository();
    final password = await userRepository.getPasswordPolicy();
    _password = Password(
      mayus: int.parse(password[0]),
      min: int.parse(password[1]),
      especial: int.parse(password[2]),
      numbers: int.parse(password[3]),
      lenght: int.parse(password[4]),
    );
    setState(() {});
  }
}
