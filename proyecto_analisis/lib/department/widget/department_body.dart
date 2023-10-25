import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/company/model/company.dart' as model;
import 'package:proyecto_analisis/department/bloc/department_bloc.dart';
import 'package:proyecto_analisis/department/model/department.dart' as model;
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class DepartmentBody extends StatefulWidget {
  const DepartmentBody({Key? key}) : super(key: key);

  @override
  State<DepartmentBody> createState() => _DepartmentBodyState();
}

class _DepartmentBodyState extends State<DepartmentBody> with ErrorHandling {
  List<model.Department> departments = [];
  late DepartmentBloc bloc;
  late String name;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _idEmpresaController = TextEditingController();
  List<model.Company> company = [];
  late model.Company dropdownValue;

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<DepartmentBloc>().add(
          Department(),
        );
    context.read<DepartmentBloc>().add(
          Company(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<DepartmentBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DepartmentBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is DepartmentSuccess) {
          setState(() {
            departments = state.departmentResponse.departments;
          });
        }
        if (state is CompanySuccess) {
          setState(() {
            company = state.companyResponse.comapnies;
            dropdownValue = company[0];
          });
        } else if (state is DepartmentEditSuccess) {
          context.read<DepartmentBloc>().add(
                Department(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado el departamento con éxito',
              ),
            ),
          );
        } else if (state is DepartmentCreateSuccess) {
          context.read<DepartmentBloc>().add(
                Department(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado el departamento con éxito',
              ),
            ),
          );
        } else if (state is DepartmentDeleteSuccess) {
          context.read<DepartmentBloc>().add(
                Department(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado el departamento con éxito',
              ),
            ),
          );
        } else if (state is DepartmentError) {
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
                        'Departamentos',
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
                            itemCount: departments.length,
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
                                        'Nombre:   ${departments[index].nombre}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Id Empresa:   ${company.firstWhere(
                                              (objeto) =>
                                                  objeto.idEmpresa ==
                                                  departments[index].idEmpresa,
                                            ).nombre}',
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
                                                      departments[index].nombre;
                                                  dropdownValue =
                                                      company.firstWhere(
                                                    (objeto) =>
                                                        objeto.idEmpresa ==
                                                        departments[index]
                                                            .idEmpresa,
                                                  );
                                                });
                                                _dialogEdit(
                                                  departments[index],
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
                                                  DepartmentDelete(
                                                    id: departments[index]
                                                        .idDepartamento,
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
          BlocBuilder<DepartmentBloc, BaseState>(
            builder: (context, state) {
              if (state is DepartmentInProgress) {
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
    final model.Department department,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Departamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              DropdownButton2<model.Company>(
                value: dropdownValue,
                items: company.map((company) {
                  return DropdownMenuItem<model.Company>(
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
                  DepartmentEdit(
                    nombre: _nombreController.text,
                    usuarioModificacion: name,
                    idEmpresa: _idEmpresaController.text,
                    idDepartamento: department.idDepartamento,
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
          title: Text('Crear Departamento'),
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
                  DropdownButton2<model.Company>(
                    value: dropdownValue,
                    items: company.map((company) {
                      return DropdownMenuItem<model.Company>(
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
                  DepartmentCreate(
                    nombre: _nombreController.text,
                    usuarioModificacion: name,
                    idEmpresa: _idEmpresaController.text,
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
