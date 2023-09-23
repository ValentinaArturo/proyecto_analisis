import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/rol/bloc/rol_bloc.dart';
import 'package:proyecto_analisis/rol/bloc/rol_event.dart';
import 'package:proyecto_analisis/rol/bloc/rol_state.dart';
import 'package:proyecto_analisis/rol/model/menu.dart';
import 'package:proyecto_analisis/rol/model/rol_response.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';
import 'package:supercharged/supercharged.dart';

import '../../common/loader/loader.dart';

class RolBody extends StatefulWidget {
  const RolBody({Key? key}) : super(key: key);

  @override
  State<RolBody> createState() => _RolBodyState();
}

class _RolBodyState extends State<RolBody> with ErrorHandling {
  final _formKey = GlobalKey<FormState>();

  List<Datum> rols = [];
  late Datum dropdownValue;
  late RolBloc bloc;

  @override
  void initState() {
    super.initState();
    dropdownValue = Datum(
      idRole: '',
      nombre: '',

    );
    context.read<RolBloc>().add(
          Rol(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<RolBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RolBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is RolSuccess) {
          setState(() {
            rols = state.rolResponse.data;
            dropdownValue = state.rolResponse.data[0];
          });
        } else if (state is OptionSuccess) {
          Navigator.pushNamed(
            context,
            dashboardRoute,
            arguments: Menu(
              state.menuResponse.data,
            ),
          );
        } else if (state is RolError) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'No tienes Roles asignados, comunicate con el administrador',
                  ),
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
                                DropdownButton<Datum>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  style:
                                      const TextStyle(color: Colors.blue),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.white,
                                  ),
                                  onChanged: (Datum? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  items: rols.map<DropdownMenuItem<Datum>>(
                                      (Datum value) {
                                    return DropdownMenuItem<Datum>(
                                      value: value,
                                      child: Text(
                                        value.nombre,
                                      ),
                                    );
                                  }).toList(),
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
                                          bloc.add(
                                            MenuOptions(
                                              int.parse(dropdownValue.idRole),
                                            ),
                                          );

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
          BlocBuilder<RolBloc, BaseState>(
            builder: (context, state) {
              if (state is RolInProgress) {
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
