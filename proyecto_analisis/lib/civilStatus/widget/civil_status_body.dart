import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/civilStatus/bloc/civil_status_bloc.dart';
import 'package:proyecto_analisis/civilStatus/model/civil_status.dart' as model;
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class CivilStatusBody extends StatefulWidget {
  const CivilStatusBody({Key? key}) : super(key: key);

  @override
  State<CivilStatusBody> createState() => _CivilStatusBodyState();
}

class _CivilStatusBodyState extends State<CivilStatusBody> with ErrorHandling {
  List<model.CivilStatus> civilStatusList = [];
  late CivilStatusBloc bloc;
  late String name;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<CivilStatusBloc>().add(
          GetCivilStatus(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<CivilStatusBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CivilStatusBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is CivilStatusSuccess) {
          setState(() {
            civilStatusList = state.success.civilStatusList;
          });
        } else if (state is CivilStatusEditSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado el estado civil con éxito',
              ),
            ),
          );
        } else if (state is CivilStatusCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado el estado civil con éxito',
              ),
            ),
          );
        } else if (state is CivilStatusDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado el estado civil con éxito',
              ),
            ),
          );
        } else if (state is CivilStatusError) {
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
                        'Estado Civil',
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
                            itemCount: civilStatusList.length,
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
                                        'Nombre:   ${civilStatusList[index].nombre}',
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
                                                  _nameController.text =
                                                      civilStatusList[index]
                                                          .nombre;
                                                });
                                                _dialogEdit(
                                                  civilStatusList[index],
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
                                                  DeleteCivilStatus(
                                                    idCivilStatus:
                                                        civilStatusList[index]
                                                            .idEstadoCivil,
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
          BlocBuilder<CivilStatusBloc, BaseState>(
            builder: (context, state) {
              if (state is CivilStatusInProgress) {
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
    final model.CivilStatus civilStatus,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Editar Estado Civil'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration:
                      InputDecoration(labelText: 'Nombre del Estado Civil'),
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
                  String civilStatusName = _nameController.text;
                  bloc.add(
                    EditCivilStatus(
                      nombre: civilStatusName,
                      idCivilStatus: civilStatus.idEstadoCivil,
                      idUsuarioModificacion: name,
                    ),
                  );
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
          title: Text('Crear Estado Civil'),
          content: IntrinsicHeight(
            child: Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration:
                        InputDecoration(labelText: 'Nombre del Estado Civil'),
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
                String civilStatusName = _nameController.text;
                bloc.add(
                  CreateCivilStatus(
                    nombre: civilStatusName,
                    idUsuarioCreacion: name,
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
