import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/rolrol/bloc/rolrol_bloc.dart';
import 'package:proyecto_analisis/rolsUser/model/rol.dart';

import '../../common/loader/loader.dart';

class RolRolBody extends StatefulWidget {
  const RolRolBody({Key? key}) : super(key: key);

  @override
  State<RolRolBody> createState() => _RolRolBodyState();
}

class _RolRolBodyState extends State<RolRolBody> with ErrorHandling {
  List<Rol> rols = [];
  late RolRolBloc bloc;
  late String name;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<RolRolBloc>().add(
          RolRol(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<RolRolBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RolRolBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is RolRolSuccess) {
          setState(() {
            rols = state.rolRolResponse.rols;
          });
        } else if (state is RolRolEditSuccess) {
          context.read<RolRolBloc>().add(
            RolRol(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado el rol con exito',
              ),
            ),
          );
        } else if (state is RolRolCreateSuccess) {
          context.read<RolRolBloc>().add(
            RolRol(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado el rol con exito',
              ),
            ),
          );
        } else if (state is RolRolDeleteSuccess) {
          context.read<RolRolBloc>().add(
            RolRol(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado el rol con exito',
              ),
            ),
          );
        } else if (state is RolRolError) {
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
                        'Roles',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _nameController.text = '';
                        });

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
                            itemCount: rols.length,
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
                                        'Nombre:   ${rols[index].nombre}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'ID:   ${rols[index].idRole}',
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
                                                _dialogEdit(
                                                  rols[index],
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
                                                    id: int.parse(
                                                        rols[index].idRole),
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
          BlocBuilder<RolRolBloc, BaseState>(
            builder: (context, state) {
              if (state is RolRolInProgress) {
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
    final Rol rol,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Editar rol'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nombre del rol'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Guardar'),
                onPressed: () {
                  String moduleName = _nameController.text;
                  bloc.add(
                    RolEdit(
                      name: moduleName,
                      id: int.parse(rol.idRole),
                      nameCreate: name,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _dialogCreate() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Crear rol'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nombre del rol'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Crear'),
                onPressed: () {
                  String moduleName = _nameController.text;
                  bloc.add(
                    RolCreate(
                      name: moduleName,
                      nameCreate: name,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _getName() async {
    final UserRepository userRepository = UserRepository();
    final name = await userRepository.getName();
    setState(() {
      this.name = name;
    });
  }
}
