import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/menu/model/menu.dart' as model;
import 'package:proyecto_analisis/option/bloc/option_bloc.dart';
import 'package:proyecto_analisis/option/model/option_response.dart' as model;
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class OptionBody extends StatefulWidget {
  const OptionBody({Key? key}) : super(key: key);

  @override
  State<OptionBody> createState() => _OptionBodyState();
}

class _OptionBodyState extends State<OptionBody> with ErrorHandling {
  List<model.Option> optionList = [];
  late OptionBloc bloc;
  late String name;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();
  final TextEditingController _oderMenuController = TextEditingController();

  List<model.Menu> menu = [];
  late model.Menu _selectedMenu;

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<OptionBloc>().add(
          GetOption(),
        );

    context.read<OptionBloc>().add(
          Menu(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<OptionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OptionBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is OptionSuccess) {
          setState(() {
            optionList = state.success.option;
          });
        } else if (state is MenuSuccess) {
          setState(() {
            menu = state.menuResponse.users;
            _selectedMenu = state.menuResponse.users.first;
          });
        } else if (state is OptionEditSuccess) {
          context.read<OptionBloc>().add(
                GetOption(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado la opción con éxito',
              ),
            ),
          );
        } else if (state is OptionCreateSuccess) {
          context.read<OptionBloc>().add(
                GetOption(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado la opción con éxito',
              ),
            ),
          );
        } else if (state is OptionDeleteSuccess) {
          context.read<OptionBloc>().add(
                GetOption(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado la opción con éxito',
              ),
            ),
          );
        } else if (state is OptionError) {
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
                        'Opción',
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
                          _pageController.text = '';
                          _oderMenuController.text = '';
                          _selectedMenu = menu.first;
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
                            itemCount: optionList.length,
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
                                        'Nombre:   ${optionList[index].nombre}',
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
                                                      optionList[index].nombre;
                                                  _pageController.text =
                                                      optionList[index].pagina;
                                                  _oderMenuController.text =
                                                      optionList[index]
                                                          .ordenMenu;
                                                  _selectedMenu =
                                                      menu.firstWhere(
                                                    (obj) =>
                                                        obj.idMenu ==
                                                        optionList[index]
                                                            .idMenu,
                                                  );
                                                });
                                                _dialogEdit(
                                                  optionList[index],
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
                                                  DeleteOption(
                                                    idOption: optionList[index]
                                                        .idOpcion,
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
          BlocBuilder<OptionBloc, BaseState>(
            builder: (context, state) {
              if (state is OptionInProgress) {
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
    final model.Option option,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Editar Opción'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration:
                        InputDecoration(labelText: 'Nombre de la Opción'),
                  ),
                  TextField(
                    controller: _pageController,
                    decoration:
                        InputDecoration(labelText: 'Nombre de la pagina'),
                  ),
                  TextField(
                    controller: _oderMenuController,
                    decoration: InputDecoration(labelText: 'Orden en el menu'),
                  ),
                  DropdownButton2<model.Menu>(
                    value: _selectedMenu,
                    items: menu.map((role) {
                      return DropdownMenuItem<model.Menu>(
                        value: role,
                        child: Text(role.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMenu = value!;
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
                    String optionName = _nameController.text;
                    bloc.add(
                      EditOption(
                        nombre: optionName,
                        idOption: int.parse(option.idOpcion),
                        idUsuarioModificacion: name,
                        pagina: _pageController.text,
                        ordenMenu: int.parse(_oderMenuController.text),
                        idMenu: int.parse(_selectedMenu.idMenu),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }

  _dialogCreate() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            title: Text('Crear Opción'),
            content: IntrinsicHeight(
              child: Container(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration:
                          InputDecoration(labelText: 'Nombre de la Opción'),
                    ),
                    TextField(
                      controller: _pageController,
                      decoration:
                          InputDecoration(labelText: 'Nombre de la pagina'),
                    ),
                    TextField(
                      controller: _oderMenuController,
                      decoration:
                          InputDecoration(labelText: 'Orden en el menu'),
                    ),
                    DropdownButton2<model.Menu>(
                      value: _selectedMenu,
                      items: menu.map((role) {
                        return DropdownMenuItem<model.Menu>(
                          value: role,
                          child: Text(role.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMenu = value!;
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
                  String optionName = _nameController.text;
                  bloc.add(
                    CreateOption(
                      nombre: optionName,
                      idUsuarioModificacion: name,
                      pagina: _pageController.text,
                      ordenMenu: int.parse(_oderMenuController.text),
                      idMenu: int.parse(_selectedMenu.idMenu),
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
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
