import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proyecto_analisis/common/textField/input.dart';
import 'package:proyecto_analisis/common/validation/validate_email.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';
import 'package:proyecto_analisis/signUp/model/genre_item.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({Key? key}) : super(key: key);

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  late bool _passwordVisible;
  int? gender;
  late GenreItem genreItemFirst;
  late GenreItem genreItemSecond;
  List<GenreItem> genres = [];

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    genreItemFirst = GenreItem(
      name: '',
      value: 0,
    );
    genreItemSecond = GenreItem(
      name: '',
      value: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      margin: const EdgeInsets.only(left: 235, right: 235),
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
                              genreItemFirst.name,
                            ),
                            value: genreItemFirst.value,
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text(
                              genreItemFirst.name,
                            ),
                            value: genreItemFirst.value,
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value;
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}
