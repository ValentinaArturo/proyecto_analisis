import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/common/textField/input.dart';
import 'package:proyecto_analisis/common/validation/validate_email.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';
import 'package:proyecto_analisis/signUp/bloc/sign_up_bloc.dart';
import 'package:proyecto_analisis/signUp/bloc/sign_up_event.dart';
import 'package:proyecto_analisis/signUp/bloc/sign_up_state.dart';
import 'package:proyecto_analisis/signUp/model/genre.dart';

import '../../common/loader/loader.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({Key? key}) : super(key: key);

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> with ErrorHandling {
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
  late GenreItem genreItemFirst;
  late GenreItem genreItemSecond;
  List<GenreItem> genres = [];
  late SignUpBloc bloc;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    genreItemFirst = GenreItem(
      idGenero: '',
      genero: '',
    );
    genreItemSecond = GenreItem(
      idGenero: '',
      genero: '',
    );
    context.read<SignUpBloc>().add(
          Genre(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<SignUpBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is SignUpSuccess) {
          Navigator.pushNamed(
            context,
            loginRoute,
          );
        } else if (state is GenreSuccess) {
          setState(() {
            genreItemFirst = state.genreResponse.genres[0];
            genreItemSecond = state.genreResponse.genres[1];
          });
        } else if (state is SignUpError) {
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 35, top: 30),
                  child: const Text(
                    'Crear\nCuenta',
                    style: TextStyle(color: Colors.white, fontSize: 33),
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
                                  label: "Fecha de nacimiento AAAA-MM-DD",
                                  controller: birthDate,
                                  isSignUp: true,
                                  inputFormatters: [
                                    MaskTextInputFormatter(mask: '####-##-##'),
                                    FilteringTextInputFormatter.digitsOnly,
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
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                                RadioListTile(
                                  title: Text(
                                    genreItemFirst.genero,
                                  ),
                                  value: genreItemFirst.idGenero,
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value as int?;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: Text(
                                    genreItemFirst.genero,
                                  ),
                                  value: genreItemFirst.idGenero,
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value as int?;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomInput(
                                  label: "Correo",
                                  controller: email,
                                  isSignUp: true,
                                  validator: (text) {
                                    validateEmail(
                                      text,
                                      context,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomInput(
                                  obscureText: true,
                                  label: "Contraseña",
                                  controller: password,
                                  isSignUp: true,
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
                                CustomInput(
                                  controller: firstQuestion,
                                  label: "1. Pregunta de seguridad",
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomInput(
                                  controller: secondQuestion,
                                  label: "2. Pregunta de seguridad",
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomInput(
                                  controller: thirdQuestion,
                                  label: "3. Pregunta de seguridad",
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 27,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: const Color(0xff4c505b),
                                      child: IconButton(
                                          color: Colors.white,
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.arrow_forward,
                                          )),
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
                                          loginRoute,
                                        );
                                      },
                                      style: const ButtonStyle(),
                                      child: const Text(
                                        'Iniciar Sesion',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
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
          BlocBuilder<SignUpBloc, BaseState>(
            builder: (context, state) {
              if (state is SignUpInProgress) {
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
