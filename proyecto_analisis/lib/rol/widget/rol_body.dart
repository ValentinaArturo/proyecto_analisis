import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';
import 'package:proyecto_analisis/signUp/bloc/sign_up_bloc.dart';
import 'package:proyecto_analisis/signUp/bloc/sign_up_state.dart';
import 'package:proyecto_analisis/signUp/model/genre.dart';

import '../../common/loader/loader.dart';

class RolBody extends StatefulWidget {
  const RolBody({Key? key}) : super(key: key);

  @override
  State<RolBody> createState() => _RolBodyState();
}

class _RolBodyState extends State<RolBody> with ErrorHandling {
  final _formKey = GlobalKey<FormState>();

  int? gender;
  late GenreItem genreItemFirst;
  late GenreItem genreItemSecond;
  late SignUpBloc bloc;

  @override
  void initState() {
    super.initState();
    genreItemFirst = GenreItem(
      idGenero: '',
      genero: '',
    );
    genreItemSecond = GenreItem(
      idGenero: '',
      genero: '',
    );
    // context.read<SignUpBloc>().add(
    //       Genre(),
    //     );
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
                  padding: const EdgeInsets.only(
                    left: 35,
                    top: 30,
                  ),
                  child: const Text(
                    'Seleccionar\nRol',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.28,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              left: 235,
                              right: 235,
                            ),
                            child: Column(
                              children: [
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
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          Navigator.pushNamed(
                                            context,
                                            dashboardRoute,
                                          );
                                        }
                                      },
                                      style: const ButtonStyle(),
                                      child: const Text(
                                        'Entrar',
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
