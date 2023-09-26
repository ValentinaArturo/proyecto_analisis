import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/rol/model/menu.dart';
import 'package:proyecto_analisis/rol/model/rol_response.dart';
import 'package:proyecto_analisis/rols/bloc/rols_bloc.dart';
import 'package:proyecto_analisis/rols/bloc/rols_event.dart';
import 'package:proyecto_analisis/rols/bloc/rols_state.dart';
import 'package:proyecto_analisis/rols/model/user.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';

import '../../common/loader/loader.dart';

class RolsBody extends StatefulWidget {
  const RolsBody({Key? key}) : super(key: key);

  @override
  State<RolsBody> createState() => _RolsBodyState();
}

class _RolsBodyState extends State<RolsBody> with ErrorHandling {
  List<Datum> rols = [];
  late Datum dropdownValue;
  late RolsBloc bloc;
  final List<User> users = [
    User('Juan', 'juan@example.com'),
    User('María', 'maria@example.com'),
    User('Pedro', 'pedro@example.com'),
  ];

  @override
  void initState() {
    super.initState();
    dropdownValue = Datum(
      idRole: '',
      nombre: '',
    );
    context.read<RolsBloc>().add(
          Rols(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<RolsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RolsBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is RolsSuccess) {
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
        } else if (state is RolsError) {
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
            },
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
                  padding: const EdgeInsets.only(
                    left: 35,
                    top: 30,
                  ),
                  child: const Text(
                    'Usuarios',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28,
                  ),
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(users[index].name),
                        subtitle: Text(users[index].email),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            userDetailRoute,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<RolsBloc, BaseState>(
            builder: (context, state) {
              if (state is RolsInProgress) {
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
