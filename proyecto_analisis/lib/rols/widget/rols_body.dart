import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/rols/bloc/rols_bloc.dart';
import 'package:proyecto_analisis/rols/bloc/rols_event.dart';
import 'package:proyecto_analisis/rols/bloc/rols_state.dart';
import 'package:proyecto_analisis/rols/model/user_response.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';

import '../../common/loader/loader.dart';

class RolsBody extends StatefulWidget {
  const RolsBody({Key? key}) : super(key: key);

  @override
  State<RolsBody> createState() => _RolsBodyState();
}

class _RolsBodyState extends State<RolsBody> with ErrorHandling {
  late RolsBloc bloc;
  List<User> users = [];
  late String name;

  @override
  void initState() {
    super.initState();
    name = '';
    _getName();
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
            users = state.userResponse.users;
          });
        } else if (state is RolsError) {
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
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 35,
                        top: 30,
                      ),
                      child: const Text(
                        'Usuarios',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            signUpRoute,
                            arguments: false,
                          );
                        },
                        child: const Text(
                          'Agregar usuario',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        color: bgColor,
                        child: Container(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.05,
                          ),
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.emoji_people,
                                        color: Colors.purpleAccent,
                                      ),
                                      title: Text(
                                        'Nombre:   ${users[index].nombre}  ${users[index].correoElectronico}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Correo:   ${users[index].correoElectronico}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      trailing: Container(
                                        width: 150,
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  userDetailRoute,
                                                  arguments: users[index],
                                                ).then((value) {
                                                  if (value != null) {
                                                    context
                                                        .read<RolsBloc>()
                                                        .add(
                                                          Rols(),
                                                        );
                                                  }
                                                });
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.lightBlue,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                bloc.add(
                                                  RolDelete(
                                                    user: name,
                                                    id: users[index].idUsuario,
                                                  ),
                                                );
                                              },
                                              child: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
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

  _getName() async {
    final UserRepository userRepository = UserRepository();
    final name = await userRepository.getUser();
    setState(() {
      this.name = name;
    });
  }
}
