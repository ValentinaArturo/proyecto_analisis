import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/status/bloc/status_bloc.dart';
import 'package:proyecto_analisis/status/model/status_user.dart' as model;

import '../../common/loader/loader.dart';

class StatusUserBody extends StatefulWidget {
  const StatusUserBody({Key? key}) : super(key: key);

  @override
  State<StatusUserBody> createState() => _StatusUserBodyState();
}

class _StatusUserBodyState extends State<StatusUserBody> with ErrorHandling {
  List<model.StatusUser> status = [];
  late StatusBloc bloc;
  late String name;
  final TextEditingController _nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<StatusBloc>().add(
      StatusUser(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<StatusBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StatusBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is StatusUserSuccess) {
          setState(() {
            status = state.statusResponse.statusUserList;
          });
        } else if (state is StatusUserEditSuccess) {
          context.read<StatusBloc>().add(
            StatusUser(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado la estatus con éxito',
              ),
            ),
          );
        } else if (state is StatusUserCreateSuccess) {
          context.read<StatusBloc>().add(
            StatusUser(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado la estatus con éxito',
              ),
            ),
          );
        } else if (state is StatusUserDeleteSuccess) {
          context.read<StatusBloc>().add(
            StatusUser(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado la estatus con éxito',
              ),
            ),
          );
        } else if (state is StatusError) {
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
                        'Status',
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
                          _nombreController.text = '';
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
                            itemCount: status.length,
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
                                        Icons.table_chart,
                                        color: Colors.purpleAccent,
                                      ),
                                      title: Text(
                                        'Nombre:   ${status[index].nombre}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Container(
                                        width: 150,
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _nombreController.text =
                                                      status[index].nombre;
                                                });
                                                _dialogEdit(
                                                  status[index],
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
                                                  StatusDelete(
                                                    id: status[index]
                                                        .idStatusUsuario.toString(),
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
          BlocBuilder<StatusBloc, BaseState>(
            builder: (context, state) {
              if (state is StatusInProgress) {
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
      final model.StatusUser status,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Editar status'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(labelText: 'Nombre'),
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
                    bloc.add(
                      StatusEdit(
                        nombre: _nombreController.text,
                        usuarioModificacion: name,
                        idStatusUsuario: status.idStatusUsuario.toString(),
                      ),
                    );
                    Navigator.of(context).pop();

                  },
                ),
              ],
            );
          }
        );
      },
    );
  }

  _dialogCreate() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Crear status'),
              content: IntrinsicHeight(
                child: Container(
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _nombreController,
                        decoration: InputDecoration(labelText: 'Nombre'),
                      ),
                    ],
                  ),
                ),
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
                    bloc.add(
                      StatusCreate(
                        nombre: _nombreController.text,
                        usuarioModificacion: name,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
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
