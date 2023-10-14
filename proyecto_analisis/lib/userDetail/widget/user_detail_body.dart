import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/common/textField/input.dart';
import 'package:proyecto_analisis/common/validation/validate_email.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/rols/model/user_response.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';
import 'package:proyecto_analisis/signUp/model/genre.dart';
import 'package:proyecto_analisis/userDetail/bloc/user_detail_bloc.dart';
import 'package:proyecto_analisis/userDetail/bloc/user_detail_event.dart';
import 'package:proyecto_analisis/userDetail/bloc/user_detail_state.dart';

import '../../common/loader/loader.dart';

class UserDetailBody extends StatefulWidget {
  final User user;

  const UserDetailBody({
    Key? key,
    required this.user,
  }) : super(key: key);

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

  int? gender;
  List<GenreItem> genres = [];
  late UserDetailBloc bloc;

  @override
  void initState() {
    super.initState();
    gender = int.parse(widget.user.idGenero);
    name.text = widget.user.nombre;
    lastName.text = widget.user.apellido;
    birthDate.text = widget.user.fechaNacimiento.toString();
    phone.text = widget.user.telefonoMovil;
    email.text = widget.user.correoElectronico;
    context.read<UserDetailBloc>().add(
          Genre(),
        );
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
            backgroundColor: secondaryColor,
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
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          bloc.add(
                                            UserDetail(
                                              email: email.text,
                                              name: name.text,
                                              lastName: lastName.text,
                                              genre: gender!,
                                              birthDate: birthDate.text,
                                              phone: phone.text,
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
}
