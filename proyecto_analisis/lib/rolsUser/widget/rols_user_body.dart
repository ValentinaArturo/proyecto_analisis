import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/rols/bloc/rols_bloc.dart';
import 'package:proyecto_analisis/rols/bloc/rols_event.dart';
import 'package:proyecto_analisis/rols/bloc/rols_state.dart';
import 'package:proyecto_analisis/rols/model/user_response.dart' as model;
import 'package:proyecto_analisis/rolsUser/model/rol.dart';
import 'package:proyecto_analisis/rolsUser/model/rol_user.dart';

import '../../common/loader/loader.dart';

class RolsUserBody extends StatefulWidget {
  const RolsUserBody({Key? key}) : super(key: key);

  @override
  State<RolsUserBody> createState() => _RolsUserBodyState();
}

class _RolsUserBodyState extends State<RolsUserBody> with ErrorHandling {
  late RolsBloc bloc;
  List<RolUser> users = [];
  List<Rol> _roles = [];
  late Rol _selectedRole;
  late String name;
  List<model.User> user = [];
  late model.User _selectedUser;

  @override
  void initState() {
    super.initState();
    name = '';
    _getName();
    _selectedRole = Rol(
      idRole: '',
      nombre: '',
      fechaCreacion: DateTime(0),
      usuarioCreacion: '',
      fechaModificacion: DateTime(0),
      usuarioModificacion: '',
    );
    _selectedUser = model.User(
      idUsuario: '',
      nombre: '',
      apellido: '',
      fechaNacimiento: DateTime(0),
      idStatusUsuario: '',
      password: '',
      idGenero: '',
      intentosDeAcceso: '',
      correoElectronico: '',
      requiereCambiarPassword: '',
      telefonoMovil: '',
      idSucursal: '',
      fechaCreacion: '',
    );
    context.read<RolsBloc>().add(
          RolsUser(),
        );
    context.read<RolsBloc>().add(
          RolList(),
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
        if (state is RolsUserSuccess) {
          setState(() {
            users = state.rolUserResponse.rols;
          });
        } else if (state is RolListSuccess) {
          setState(() {
            _roles = state.rolResponse.rols;
            _selectedRole = state.rolResponse.rols.first;
          });
        } else if (state is RolsUserEditSuccess) {
          context.read<RolsBloc>().add(
            RolsUser(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado el rol-usuario con exito',
              ),
            ),
          );
        } else if (state is RolsUserCreateSuccess) {
          context.read<RolsBloc>().add(
            RolsUser(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado el rol-usuario con exito',
              ),
            ),
          );
        } else if (state is RolsUserDeleteSuccess) {
          context.read<RolsBloc>().add(
            RolsUser(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado el rol-usuario con exito',
              ),
            ),
          );
        } else if (state is RolsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error!,
              ),
            ),
          );
        } else if (state is RolsSuccess) {
          setState(() {
            user = state.userResponse.users;
            _selectedUser = state.userResponse.users.first;
          });
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
                        'Roles Usuarios',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _dialogCreate();
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.green,
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
                                        Icons.people,
                                        color: Colors.purpleAccent,
                                      ),
                                      title: Text(
                                        'Nombre:   ${users[index].nombreUsuario}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Rol:   ${users[index].nombreRol}',
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
                                                setState(() {
                                                  _selectedRole =
                                                      _roles.firstWhere(
                                                    (obj) =>
                                                        obj.nombre ==
                                                        users[index].nombreRol,
                                                  );
                                                });
                                                _dialogEdit(
                                                  users[index],
                                                );
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
                                                    user: users[index]
                                                        .nombreUsuario,
                                                    id: _roles
                                                        .firstWhere(
                                                          (obj) =>
                                                              obj.nombre ==
                                                              users[index]
                                                                  .nombreRol,
                                                        )
                                                        .idRole,
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

  _dialogEdit(
    final RolUser user,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona un rol'),
          content: DropdownButton2<Rol>(
            value: _selectedRole,
            items: _roles.map((role) {
              return DropdownMenuItem<Rol>(
                value: role,
                child: Text(role.nombre ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Editar'),
              onPressed: () {
                bloc.add(
                  RolEdit(
                    user: name,
                    id: _selectedRole.idRole,
                    userCreate: name,
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _dialogCreate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona un usuario rol'),
          content: Column(
            children: [
              DropdownButton2<Rol>(
                value: _selectedRole,
                items: _roles.map((role) {
                  return DropdownMenuItem<Rol>(
                    value: role,
                    child: Text(role.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              DropdownButton2<model.User>(
                value: _selectedUser,
                items: user.map((user) {
                  return DropdownMenuItem<model.User>(
                    value: user,
                    child: Text(user.correoElectronico),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUser = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Crear'),
              onPressed: () {
                bloc.add(
                  RolCreate(
                    user: name,
                    id: _selectedRole.idRole,
                    userCreate: name,
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
