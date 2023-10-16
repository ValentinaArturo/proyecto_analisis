import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/modules/bloc/modules_bloc.dart';
import 'package:proyecto_analisis/modules/model/modules.dart' as Module;
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class ModulesBody extends StatefulWidget {
  const ModulesBody({Key? key}) : super(key: key);

  @override
  State<ModulesBody> createState() => _ModulesBodyState();
}

class _ModulesBodyState extends State<ModulesBody> with ErrorHandling {
  List<Module.Modules> modules = [];
  late ModulesBloc bloc;
  late String name;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _menuNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<ModulesBloc>().add(
          Modules(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<ModulesBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ModulesBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is ModulesSuccess) {
          setState(() {
            modules = state.modulesResponse.users;
          });
        } else if (state is ModulesEditSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado el modulo con exito',
              ),
            ),
          );
        } else if (state is ModulesCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado el modulo con exito',
              ),
            ),
          );
        } else if (state is ModulesDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado el modulo con exito',
              ),
            ),
          );
        } else if (state is ModulesError) {
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
                        'Modulos',
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
                            itemCount: modules.length,
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
                                        'Nombre:   ${modules[index].nombre}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Orden en el Menu:   ${modules[index].ordenMenu}',
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
                                                  _menuNumberController.text =
                                                      modules[index]
                                                          .ordenMenu
                                                          .toString();
                                                  _nameController.text =
                                                      modules[index].nombre;
                                                });
                                                _dialogEdit(
                                                  modules[index],
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
                                                  _menuNumberController.text =
                                                      '';
                                                  _nameController.text = '';
                                                });

                                                _dialogCreate(
                                                  modules[index],
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
                                                  ModuleDelete(
                                                    id: modules[index].idModulo,
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
          BlocBuilder<ModulesBloc, BaseState>(
            builder: (context, state) {
              if (state is ModulesInProgress) {
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
    final Module.Modules module,
  ) {
    AlertDialog(
      title: Text('Editar módulo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nombre del módulo'),
          ),
          TextField(
            controller: _menuNumberController,
            decoration: InputDecoration(labelText: 'Número de menú'),
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
            String moduleName = _nameController.text;
            String menuNumber = _menuNumberController.text;
            bloc.add(
              ModuleEdit(
                name: moduleName,
                id: module.idModulo,
                nameCreate: name,
                menuOrder: menuNumber,
              ),
            );
          },
        ),
      ],
    );
  }

  _dialogCreate(
    final Module.Modules user,
  ) {
    AlertDialog(
      title: Text('Crear módulo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nombre del módulo'),
          ),
          TextField(
            controller: _menuNumberController,
            decoration: InputDecoration(labelText: 'Número de menú'),
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
          child: Text('Crear'),
          onPressed: () {
            String moduleName = _nameController.text;
            String menuNumber = _menuNumberController.text;
            bloc.add(
              ModuleCreate(
                name: moduleName,
                nameCreate: name,
                menuOrder: menuNumber,
              ),
            );
          },
        ),
      ],
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
