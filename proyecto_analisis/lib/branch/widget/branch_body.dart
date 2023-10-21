import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/branch/bloc/branch_bloc.dart';
import 'package:proyecto_analisis/branch/model/branch.dart' as model;
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class BranchBody extends StatefulWidget {
  const BranchBody({Key? key}) : super(key: key);

  @override
  State<BranchBody> createState() => _BranchBodyState();
}

class _BranchBodyState extends State<BranchBody> with ErrorHandling {
  List<model.Branch> branch = [];
  late BranchBloc bloc;
  late String name;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<BranchBloc>().add(
          Branch(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<BranchBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is BranchSuccess) {
          setState(() {
            branch = state.branchResponse.branches;
          });
        } else if (state is BranchEditSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado la sucursal con éxito',
              ),
            ),
          );
        } else if (state is BranchCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado la sucursal con éxito',
              ),
            ),
          );
        } else if (state is BranchDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado la sucursal con éxito',
              ),
            ),
          );
        } else if (state is BranchError) {
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
                        'Sucursal',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
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
                            itemCount: branch.length,
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
                                        'Nombre:   ${branch[index].nombre}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Dirección:   ${branch[index].direccion}',
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
                                                  _addressController.text =
                                                      branch[index]
                                                          .idBranch
                                                          .toString();
                                                  _nameController.text =
                                                      branch[index].nombre;
                                                  _addressController.text =
                                                      branch[index].idEmpresa;
                                                });
                                                _dialogEdit(
                                                  branch[index],
                                                );
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.lightBlue,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _addressController.text = '';
                                                  _nameController.text = '';
                                                });

                                                _dialogCreate(
                                                  branch[index],
                                                );
                                              },
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.green,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                bloc.add(
                                                  BranchDelete(
                                                    idBranch:
                                                        branch[index].idBranch,
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
          BlocBuilder<BranchBloc, BaseState>(
            builder: (context, state) {
              if (state is BranchInProgress) {
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
    final model.Branch branch,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Editar sucursal'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration:
                      InputDecoration(labelText: 'Nombre de la sucursal'),
                ),
                TextField(
                  controller: _addressController,
                  decoration:
                      InputDecoration(labelText: 'Direccion de sucursal'),
                  keyboardType: TextInputType.number,
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
                  String branchName = _nameController.text;
                  String branchNumber = _addressController.text;
                  bloc.add(
                    BranchEdit(
                      nombre: branchName,
                      id: branch.idEmpresa,
                      idBranch: branch.idBranch,
                      idEmpresa: branch.idEmpresa,
                      direccion: branchNumber,
                      usuarioCreacion: name,
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  _dialogCreate(
    final model.Branch branch,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Crear sucursal'),
          content: IntrinsicHeight(
            child: Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration:
                        InputDecoration(labelText: 'Nombre de la sucursal'),
                  ),
                  TextField(
                    controller: _addressController,
                    decoration:
                        InputDecoration(labelText: 'Número de sucursal'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _companyController,
                    decoration: InputDecoration(labelText: 'ID de Empresa'),
                    keyboardType: TextInputType.number,
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
                String branchName = _nameController.text;
                String branchNumber = _addressController.text;
                bloc.add(
                  BranchCreate(
                    nombre: branchName,
                    usuarioCreacion: name,
                    direccion: branchNumber,
                    id: branch.idEmpresa,
                    idEmpresa: _companyController.text,
                  ),
                );
                Navigator.of(context)
                    .pop(); // Cerrar el cuadro de diálogo después de crear la sucursal.
              },
            ),
          ],
        );
      },
    );
  }

  _getName() async {
    final UserRepository userRepository = UserRepository();
    final name = await userRepository.getName();
    setState(() {
      this.name = name;
    });
  }
}
