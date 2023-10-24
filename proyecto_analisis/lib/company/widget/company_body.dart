import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/company/bloc/company_bloc.dart';
import 'package:proyecto_analisis/company/bloc/company_event.dart';
import 'package:proyecto_analisis/company/bloc/company_state.dart';
import 'package:proyecto_analisis/company/model/company.dart' as model;
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class CompanyBody extends StatefulWidget {
  const CompanyBody({Key? key}) : super(key: key);

  @override
  State<CompanyBody> createState() => _CompanyBodyState();
}

class _CompanyBodyState extends State<CompanyBody> with ErrorHandling {
  List<model.Company> company = [];
  late CompanyBloc bloc;
  late String name;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _nitController = TextEditingController();
  final TextEditingController _passwordCantidadMayusculasController =
      TextEditingController();
  final TextEditingController _passwordCantidadMinusculasController =
      TextEditingController();
  final TextEditingController _passwordCantidadCaracteresEspecialesController =
      TextEditingController();
  final TextEditingController _passwordCantidadCaducidadDiasController =
      TextEditingController();
  final TextEditingController _passwordLargoController =
      TextEditingController();
  final TextEditingController _passwordIntentosAntesDeBloquearController =
      TextEditingController();
  final TextEditingController _passwordCantidadNumerosController =
      TextEditingController();
  final TextEditingController _passwordCantidadPreguntasValidarController =
      TextEditingController();
  final TextEditingController _nameCreateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<CompanyBloc>().add(
          Company(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<CompanyBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompanyBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is CompanySuccess) {
          setState(() {
            company = state.companyResponse.comapnies;
          });
        } else if (state is CompanyEditSuccess) {
          context.read<CompanyBloc>().add(
            Company(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado la empresa con exito',
              ),
            ),
          );
        } else if (state is CompanyCreateSuccess) {
          context.read<CompanyBloc>().add(
            Company(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado la empresa con exito',
              ),
            ),
          );
        } else if (state is CompanyDeleteSuccess) {
          context.read<CompanyBloc>().add(
            Company(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado la empresa con exito',
              ),
            ),
          );
        } else if (state is CompanyError) {
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
                        'Empresas',
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
                          _direccionController.text = '';
                          _nitController.text = '';
                          _passwordCantidadCaducidadDiasController.text = '';
                          _passwordCantidadCaracteresEspecialesController.text =
                              '';
                          _passwordCantidadMayusculasController.text = '';
                          _passwordCantidadMinusculasController.text = '';
                          _passwordCantidadNumerosController.text = '';
                          _passwordCantidadPreguntasValidarController.text = '';
                          _passwordIntentosAntesDeBloquearController.text = '';
                          _passwordLargoController.text = '';
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
                            itemCount: company.length,
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
                                        Icons.vertical_shades_outlined,
                                        color: Colors.purpleAccent,
                                      ),
                                      title: Text(
                                        'Nombre:   ${company[index].nombre}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Direccion:   ${company[index].direccion}',
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
                                                      company[index].nombre;
                                                  _direccionController.text =
                                                      company[index].direccion;
                                                  _nitController.text =
                                                      company[index].nit;
                                                  _passwordCantidadCaducidadDiasController
                                                      .text = company[
                                                          index]
                                                      .passwordCantidadCaducidadDias;
                                                  _passwordCantidadCaracteresEspecialesController
                                                      .text = company[
                                                          index]
                                                      .passwordCantidadCaracteresEspeciales;
                                                  _passwordCantidadMayusculasController
                                                      .text = company[
                                                          index]
                                                      .passwordCantidadMayusculas;
                                                  _passwordCantidadMinusculasController
                                                      .text = company[
                                                          index]
                                                      .passwordCantidadMinusculas;
                                                  _passwordCantidadNumerosController
                                                      .text = company[
                                                          index]
                                                      .passwordCantidadNumeros;
                                                  _passwordCantidadPreguntasValidarController
                                                      .text = company[
                                                          index]
                                                      .passwordCantidadPreguntasValidar;
                                                  _passwordIntentosAntesDeBloquearController
                                                      .text = company[
                                                          index]
                                                      .passwordIntentosAntesDeBloquear;
                                                  _passwordLargoController
                                                          .text =
                                                      company[index]
                                                          .passwordLargo;
                                                });
                                                _dialogEdit(
                                                  company[index],
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
                                                  CompanyDelete(
                                                    id: company[index]
                                                        .idEmpresa,
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
          BlocBuilder<CompanyBloc, BaseState>(
            builder: (context, state) {
              if (state is CompanyInProgress) {
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
    final model.Company company,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Editar empresa'),
            content: SingleChildScrollView(
              child: Container(
                width: 800,
                height: 800,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: 'Nombre de la empresa'),
                    ),
                    TextField(
                      controller: _direccionController,
                      decoration: const InputDecoration(labelText: 'Dirección'),
                    ),
                    TextField(
                      controller: _nitController,
                      decoration: const InputDecoration(labelText: 'NIT'),
                    ),
                    TextField(
                      controller: _passwordCantidadMayusculasController,
                      decoration: const InputDecoration(
                          labelText: 'Cantidad de Mayúsculas en la Contraseña'),
                    ),
                    TextField(
                      controller: _passwordCantidadMinusculasController,
                      decoration: const InputDecoration(
                          labelText: 'Cantidad de Minúsculas en la Contraseña'),
                    ),
                    TextField(
                      controller: _passwordCantidadCaracteresEspecialesController,
                      decoration: const InputDecoration(
                          labelText:
                              'Cantidad de Caracteres Especiales en la Contraseña'),
                    ),
                    TextField(
                      controller: _passwordCantidadCaducidadDiasController,
                      decoration: const InputDecoration(
                          labelText: 'Días de Caducidad de la Contraseña'),
                    ),
                    TextField(
                      controller: _passwordLargoController,
                      decoration: const InputDecoration(
                          labelText: 'Largo de la Contraseña'),
                    ),
                    TextField(
                      controller: _passwordIntentosAntesDeBloquearController,
                      decoration: const InputDecoration(
                          labelText: 'Intentos antes de Bloquear la Contraseña'),
                    ),
                    TextField(
                      controller: _passwordCantidadNumerosController,
                      decoration: const InputDecoration(
                          labelText: 'Cantidad de Números en la Contraseña'),
                    ),
                    TextField(
                      controller: _passwordCantidadPreguntasValidarController,
                      decoration: const InputDecoration(
                          labelText: 'Cantidad de Preguntas para Validar'),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Guardar'),
                onPressed: () {
                  bloc.add(
                    CompanyEdit(
                      name: _nameController.text,
                      direccion: _direccionController.text,
                      nit: _nitController.text,
                      passwordCantidadMayusculas:
                          _passwordCantidadMayusculasController.text,
                      passwordCantidadMinusculas:
                          _passwordCantidadMinusculasController.text,
                      passwordCantidadCaracteresEspeciales:
                          _passwordCantidadCaracteresEspecialesController.text,
                      passwordCantidadCaducidadDias:
                          _passwordCantidadCaducidadDiasController.text,
                      passwordLargo: _passwordLargoController.text,
                      passwordIntentosAntesDeBloquear:
                          _passwordIntentosAntesDeBloquearController.text,
                      passwordCantidadNumeros:
                          _passwordCantidadNumerosController.text,
                      passwordCantidadPreguntasValidar:
                          _passwordCantidadPreguntasValidarController.text,
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
          return SizedBox(
            child: AlertDialog(
              title: const Text('Crear empresa'),
              content: SingleChildScrollView(
                child: Container(
                  width: 800,
                  height: 800,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(labelText: 'Nombre de la empresa'),
                      ),
                      TextField(
                        controller: _direccionController,
                        decoration: const InputDecoration(labelText: 'Dirección'),
                      ),
                      TextField(
                        controller: _nitController,
                        decoration: const InputDecoration(labelText: 'NIT'),
                      ),
                      TextField(
                        controller: _passwordCantidadMayusculasController,
                        decoration: const InputDecoration(
                            labelText: 'Cantidad de Mayúsculas en la Contraseña'),
                      ),
                      TextField(
                        controller: _passwordCantidadMinusculasController,
                        decoration: const InputDecoration(
                            labelText: 'Cantidad de Minúsculas en la Contraseña'),
                      ),
                      TextField(
                        controller: _passwordCantidadCaracteresEspecialesController,
                        decoration: const InputDecoration(
                            labelText:
                                'Cantidad de Caracteres Especiales en la Contraseña'),
                      ),
                      TextField(
                        controller: _passwordCantidadCaducidadDiasController,
                        decoration: const InputDecoration(
                            labelText: 'Días de Caducidad de la Contraseña'),
                      ),
                      TextField(
                        controller: _passwordLargoController,
                        decoration: const InputDecoration(
                            labelText: 'Largo de la Contraseña'),
                      ),
                      TextField(
                        controller: _passwordIntentosAntesDeBloquearController,
                        decoration: const InputDecoration(
                            labelText: 'Intentos antes de Bloquear la Contraseña'),
                      ),
                      TextField(
                        controller: _passwordCantidadNumerosController,
                        decoration: const InputDecoration(
                            labelText: 'Cantidad de Números en la Contraseña'),
                      ),
                      TextField(
                        controller: _passwordCantidadPreguntasValidarController,
                        decoration: const InputDecoration(
                            labelText: 'Cantidad de Preguntas para Validar'),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Crear'),
                  onPressed: () {
                    bloc.add(
                      CompanyCreate(
                        name: _nameController.text,
                        direccion: _direccionController.text,
                        nit: _nitController.text,
                        passwordCantidadMayusculas:
                            _passwordCantidadMayusculasController.text,
                        passwordCantidadMinusculas:
                            _passwordCantidadMinusculasController.text,
                        passwordCantidadCaracteresEspeciales:
                            _passwordCantidadCaracteresEspecialesController.text,
                        passwordCantidadCaducidadDias:
                            _passwordCantidadCaducidadDiasController.text,
                        passwordLargo: _passwordLargoController.text,
                        passwordIntentosAntesDeBloquear:
                            _passwordIntentosAntesDeBloquearController.text,
                        passwordCantidadNumeros:
                            _passwordCantidadNumerosController.text,
                        passwordCantidadPreguntasValidar:
                            _passwordCantidadPreguntasValidarController.text,
                        nameCreate: name,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
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
