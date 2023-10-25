import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/department/model/department.dart' as model;
import 'package:proyecto_analisis/position/bloc/position_bloc.dart';
import 'package:proyecto_analisis/position/model/position.dart' as model;
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class PositionBody extends StatefulWidget {
  const PositionBody({Key? key}) : super(key: key);

  @override
  State<PositionBody> createState() => _PositionBodyState();
}

class _PositionBodyState extends State<PositionBody> with ErrorHandling {
  List<model.Position> position = [];
  late PositionBloc bloc;
  late String name;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _idDepartamentoController =
      TextEditingController();
  List<model.Department> departments = [];
  late model.Department dropdownValue;

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<PositionBloc>().add(
          Position(),
        );
    context.read<PositionBloc>().add(
          Department(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<PositionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PositionBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is PositionSuccess) {
          setState(() {
            position = state.positionResponse.positions;
          });
        } else if (state is DepartmentSuccess) {
          setState(() {
            departments = state.departmentResponse.departments;
            dropdownValue = departments[0];
          });
        } else if (state is PositionEditSuccess) {
          context.read<PositionBloc>().add(
                Position(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado la posición con éxito',
              ),
            ),
          );
        } else if (state is PositionCreateSuccess) {
          context.read<PositionBloc>().add(
                Position(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado la posición con éxito',
              ),
            ),
          );
        } else if (state is PositionDeleteSuccess) {
          context.read<PositionBloc>().add(
                Position(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado la posición con éxito',
              ),
            ),
          );
        } else if (state is PositionError) {
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
                        'Puestos',
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
                          _idDepartamentoController.text = '';
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
                            itemCount: position.length,
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
                                        'Nombre:   ${position[index].nombre}',
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
                                                      position[index].nombre;
                                                  dropdownValue = departments
                                                      .firstWhere((objeto) =>
                                                          objeto
                                                              .idDepartamento ==
                                                          position[index]
                                                              .idDepartamento);
                                                });
                                                _dialogEdit(
                                                  position[index],
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
                                                  PositionDelete(
                                                    id: position[index]
                                                        .idPuesto,
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
          BlocBuilder<PositionBloc, BaseState>(
            builder: (context, state) {
              if (state is PositionInProgress) {
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
    final model.Position position,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Editar Posición'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                  ),
                  DropdownButton2<model.Department>(
                    value: dropdownValue,
                    items: departments.map((company) {
                      return DropdownMenuItem<model.Department>(
                        value: company,
                        child: Text(company.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
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
                      PositionEdit(
                        nombre: _nombreController.text,
                        idDepartamento: _idDepartamentoController.text,
                        usuarioModificacion: name,
                        idPuesto: position.idPuesto,
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
              title: Text('Crear posición'),
              content: IntrinsicHeight(
                child: Container(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _nombreController,
                        decoration: InputDecoration(labelText: 'Nombre'),
                      ),
                      DropdownButton2<model.Department>(
                        value: dropdownValue,
                        items: departments.map((company) {
                          return DropdownMenuItem<model.Department>(
                            value: company,
                            child: Text(company.nombre),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
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
                      PositionCreate(
                        nombre: _nombreController.text,
                        idDepartamento: _idDepartamentoController.text,
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
