import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/menu/bloc/menu_bloc.dart';
import 'package:proyecto_analisis/menu/model/menu.dart' as model;
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class MenuBody extends StatefulWidget {
  const MenuBody({Key? key}) : super(key: key);

  @override
  State<MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends State<MenuBody> with ErrorHandling {
  List<model.Menu> menu = [];
  late MenuBloc bloc;
  late String name;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _menuNumberController = TextEditingController();
  final TextEditingController _moduleNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<MenuBloc>().add(
          Menu(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<MenuBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is MenuSuccess) {
          setState(() {
            menu = state.menuResponse.users;
          });
        } else if (state is MenuEditSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado el menu con exito',
              ),
            ),
          );
        } else if (state is MenuCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado el menu con exito',
              ),
            ),
          );
        } else if (state is MenuDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado el menu con exito',
              ),
            ),
          );
        } else if (state is MenuError) {
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
                        'Menu',
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
                            itemCount: menu.length,
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
                                        'Nombre:   ${menu[index].nombre}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Text(
                                            'Modulo:   ${menu[index].idModulo}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Orden en el Menu:   ${menu[index].ordenMenu}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Container(
                                        width: 150,
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _menuNumberController.text =
                                                      menu[index]
                                                          .ordenMenu
                                                          .toString();
                                                  _nameController.text =
                                                      menu[index].nombre;
                                                  _menuNumberController.text =
                                                      menu[index].idModulo;
                                                });
                                                _dialogEdit(
                                                  menu[index],
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
                                                  menu[index],
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
                                                  MenuDelete(
                                                    id: menu[index].idMenu,
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
          BlocBuilder<MenuBloc, BaseState>(
            builder: (context, state) {
              if (state is MenuInProgress) {
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
    final model.Menu menu,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Editar módulo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nombre del menu'),
                ),
                TextField(
                  controller: _menuNumberController,
                  decoration: InputDecoration(labelText: 'Número de menú'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _moduleNumberController,
                  decoration: InputDecoration(labelText: 'Número de modulo'),
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
                    MenuEdit(
                      name: moduleName,
                      id: menu.idModulo,
                      nameCreate: name,
                      menuOrder: menuNumber,
                      idMenu: menu.idMenu,
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  _dialogCreate(
    final model.Menu menu,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Crear menu'),
            content: IntrinsicHeight(
              child: Container(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Nombre del menu'),
                    ),
                    TextField(
                      controller: _menuNumberController,
                      decoration: InputDecoration(labelText: 'Número de menú'),
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
                  String moduleName = _nameController.text;
                  String menuNumber = _menuNumberController.text;
                  bloc.add(
                    MenuCreate(
                      name: moduleName,
                      nameCreate: name,
                      menuOrder: menuNumber,
                      id: menu.idModulo,
                    ),
                  );
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
