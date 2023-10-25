import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/civilStatus/model/civil_status.dart' as model;
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/genres/model/genres.dart';
import 'package:proyecto_analisis/person/bloc/person_bloc.dart';
import 'package:proyecto_analisis/person/model/person.dart' as model;
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class PersonBody extends StatefulWidget {
  const PersonBody({Key? key}) : super(key: key);

  @override
  State<PersonBody> createState() => _PersonBodyState();
}

class _PersonBodyState extends State<PersonBody> with ErrorHandling {
  List<model.Person> person = [];
  late PersonBloc bloc;
  late String name;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _idGeneroController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoElectronicoController =
      TextEditingController();
  final TextEditingController _idEstadoCivilController =
      TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();
  List<model.CivilStatus> civilStatusList = [];
  List<Genre> genres = [];
  late model.CivilStatus dropdownValueS;
  late Genre dropdownValueG;

  @override
  void initState() {
    super.initState();
    dropdownValueG = Genre(
      idGenero: '',
      nombre: '',
    );
    dropdownValueS = model.CivilStatus(
      idEstadoCivil: '',
      nombre: '',
      usuarioModificacion: '',
      fechaModificacion: '',
      fechaCreacion: DateTime(0),
      usuarioCreacion: '',
    );
    _getName();
    context.read<PersonBloc>().add(
          Person(),
        );
    context.read<PersonBloc>().add(
          Genres(),
        );
    context.read<PersonBloc>().add(
          GetCivilStatus(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<PersonBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PersonBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is PersonSuccess) {
          setState(() {
            person = state.personResponse.users;
          });
        } else if (state is GenresSuccess) {
          setState(() {
            genres = state.genresResponse.users;
            dropdownValueG = state.genresResponse.users[0];
          });
        } else if (state is CivilStatusSuccess) {
          setState(() {
            civilStatusList = state.success.civilStatusList;
            dropdownValueS = state.success.civilStatusList[0];
          });
        } else if (state is PersonEditSuccess) {
          context.read<PersonBloc>().add(
            Person(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado la persona con éxito',
              ),
            ),
          );
        } else if (state is PersonCreateSuccess) {
          context.read<PersonBloc>().add(
            Person(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado la persona con éxito',
              ),
            ),
          );
        } else if (state is PersonDeleteSuccess) {
          context.read<PersonBloc>().add(
            Person(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado la persona con éxito',
              ),
            ),
          );
        } else if (state is PersonError) {
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
                        'Personas',
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
                          _direccionController.text = '';
                          _idGeneroController.text = '';
                          _telefonoController.text = '';
                          _correoElectronicoController.text = '';
                          _idEstadoCivilController.text = '';
                          _apellidoController.text = '';
                          _fechaNacimientoController.text = '';
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
                            itemCount: person.length,
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
                                        'Nombre:   ${person[index].nombre} ${person[index].apellido}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Text(
                                            'Correo:   ${person[index].correoElectronico}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Direccion:   ${person[index].direccion}',
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
                                                  _nombreController.text =
                                                      person[index].nombre;
                                                  _direccionController.text =
                                                      person[index].direccion;
                                                  dropdownValueG =
                                                      genres.firstWhere(
                                                    (objeto) =>
                                                        objeto.idGenero ==
                                                        person[index].idGenero,
                                                  );
                                                  dropdownValueS =
                                                      civilStatusList
                                                          .firstWhere(
                                                    (objeto) =>
                                                        objeto.idEstadoCivil ==
                                                        person[index]
                                                            .idEstadoCivil,
                                                  );
                                                  _idGeneroController.text =
                                                      person[index].idGenero;
                                                  _telefonoController.text =
                                                      person[index].telefono;
                                                  _correoElectronicoController
                                                          .text =
                                                      person[index]
                                                          .correoElectronico;
                                                  _idEstadoCivilController
                                                          .text =
                                                      person[index]
                                                          .idEstadoCivil;
                                                  _apellidoController.text =
                                                      person[index].apellido;
                                                  _fechaNacimientoController
                                                          .text =
                                                      person[index]
                                                          .fechaNacimiento;
                                                });
                                                _dialogEdit(
                                                  person[index],
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
                                                  PersonDelete(
                                                    id: person[index].idPersona,
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
          BlocBuilder<PersonBloc, BaseState>(
            builder: (context, state) {
              if (state is PersonInProgress) {
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
    final model.Person person,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Persona'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _direccionController,
                decoration: InputDecoration(labelText: 'Dirección'),
              ),
              DropdownButton2<Genre>(
                value: dropdownValueG,
                items: genres.map((company) {
                  return DropdownMenuItem<Genre>(
                    value: company,
                    child: Text(company.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    dropdownValueG = value!;
                  });
                },
              ),
              TextField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
              ),
              TextField(
                controller: _correoElectronicoController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
              ),
              DropdownButton2<model.CivilStatus>(
                value: dropdownValueS,
                items: civilStatusList.map((company) {
                  return DropdownMenuItem<model.CivilStatus>(
                    value: company,
                    child: Text(company.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    dropdownValueS = value!;
                  });
                },
              ),
              TextField(
                controller: _apellidoController,
                decoration: InputDecoration(labelText: 'Apellido'),
              ),
              TextField(
                controller: _fechaNacimientoController,
                decoration: InputDecoration(labelText: 'Fecha de Nacimiento'),
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
                  PersonEdit(
                    nombre: _nombreController.text,
                    direccion: _direccionController.text,
                    usuarioModificacion: name,
                    idGenero: dropdownValueG.idGenero,
                    telefono: _telefonoController.text,
                    correoElectronico: _correoElectronicoController.text,
                    idEstadoCivil: dropdownValueS.idEstadoCivil,
                    apellido: _apellidoController.text,
                    fechaNacimiento: _fechaNacimientoController.text,
                    id: person.idPersona,
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
      builder: (context) {
        return AlertDialog(
          title: Text('Crear persona'),
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
                  TextField(
                    controller: _direccionController,
                    decoration: InputDecoration(labelText: 'Dirección'),
                  ),
                  DropdownButton2<Genre>(
                    value: dropdownValueG,
                    items: genres.map((company) {
                      return DropdownMenuItem<Genre>(
                        value: company,
                        child: Text(company.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValueG = value!;
                      });
                    },
                  ),
                  TextField(
                    controller: _telefonoController,
                    decoration: InputDecoration(labelText: 'Teléfono'),
                  ),
                  TextField(
                    controller: _correoElectronicoController,
                    decoration:
                        InputDecoration(labelText: 'Correo Electrónico'),
                  ),
                  DropdownButton2<model.CivilStatus>(
                    value: dropdownValueS,
                    items: civilStatusList.map((company) {
                      return DropdownMenuItem<model.CivilStatus>(
                        value: company,
                        child: Text(company.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValueS = value!;
                      });
                    },
                  ),
                  TextField(
                    controller: _apellidoController,
                    decoration: InputDecoration(labelText: 'Apellido'),
                  ),
                  TextField(
                    controller: _fechaNacimientoController,
                    decoration:
                        InputDecoration(labelText: 'Fecha de Nacimiento'),
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
                  PersonCreate(
                    nombre: _nombreController.text,
                    direccion: _direccionController.text,
                    idGenero: dropdownValueG.idGenero,
                    telefono: _telefonoController.text,
                    correoElectronico: _correoElectronicoController.text,
                    idEstadoCivil: dropdownValueS.idEstadoCivil,
                    apellido: _apellidoController.text,
                    fechaNacimiento: _fechaNacimientoController.text,
                    usuarioCreacion: name,
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
