import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/genres/bloc/genres_bloc.dart';
import 'package:proyecto_analisis/genres/bloc/genres_event.dart';
import 'package:proyecto_analisis/genres/bloc/genres_state.dart';
import 'package:proyecto_analisis/genres/model/genres.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class GenresBody extends StatefulWidget {
  const GenresBody({Key? key}) : super(key: key);

  @override
  State<GenresBody> createState() => _GenresBodyState();
}

class _GenresBodyState extends State<GenresBody> with ErrorHandling {
  List<Genre> genres = [];
  late GenresBloc bloc;
  late String name;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<GenresBloc>().add(
          Genres(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<GenresBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GenresBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is GenresSuccess) {
          setState(() {
            genres = state.genresResponse.users;
          });
        } else if (state is GenresEditSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado el genero con exito',
              ),
            ),
          );
        } else if (state is GenresCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado el genero con exito',
              ),
            ),
          );
        } else if (state is GenresDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado el genero con exito',
              ),
            ),
          );
        } else if (state is GenresError) {
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
                        'Generos',
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
                            itemCount: genres.length,
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
                                        Icons.insert_emoticon,
                                        color: Colors.purpleAccent,
                                      ),
                                      title: Text(
                                        'Nombre:   ${genres[index].nombre}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'ID:   ${genres[index].idGenero}',
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
                                                  _nameController.text =
                                                      genres[index].nombre;
                                                });
                                                _dialogEdit(
                                                  genres[index],
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
                                                  GenreDelete(
                                                    id: genres[index].idGenero,
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
          BlocBuilder<GenresBloc, BaseState>(
            builder: (context, state) {
              if (state is GenresInProgress) {
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
    final Genre genre,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, StateSetter setState) {
              return AlertDialog(
                title: Text('Editar genero'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Nombre del genero'),
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
                        GenreEdit(
                          name: _nameController.text,
                          id: genre.idGenero,
                          nameCreate: name,
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          );
        });
  }

  _dialogCreate() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, StateSetter setState) {
              return AlertDialog(
                title: Text('Crear genero'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Nombre del genero'),
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
                      bloc.add(
                        GenreCreate(
                          name: _nameController.text,
                          nameCreate: name,
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          );
        });
  }

  _getName() async {
    final UserRepository userRepository = UserRepository();
    final name = await userRepository.getUser();
    setState(() {
      this.name = name;
    });
  }
}
