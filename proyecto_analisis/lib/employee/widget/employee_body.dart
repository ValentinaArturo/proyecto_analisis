import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/branch/model/branch.dart' as model;
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/employee/bloc/employee_bloc.dart';
import 'package:proyecto_analisis/employee/model/employee.dart' as model;
import 'package:proyecto_analisis/person/model/person.dart' as model;
import 'package:proyecto_analisis/position/model/position.dart' as model;
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/status/model/status.dart' as model;

import '../../common/loader/loader.dart';

class EmployeeBody extends StatefulWidget {
  const EmployeeBody({Key? key}) : super(key: key);

  @override
  State<EmployeeBody> createState() => _EmployeeBodyState();
}

class _EmployeeBodyState extends State<EmployeeBody> with ErrorHandling {
  List<model.Employee> employees = [];
  List<model.Person> person = [];
  List<model.Branch> branch = [];
  List<model.Position> position = [];
  List<model.Status> status = [];
  late model.Person dropdownValue;
  late model.Branch dropdownValueBranch;
  late model.Position dropdownValuePosition;
  late model.Status dropdownValueStatus;

  late EmployeeBloc bloc;
  late String name;
  final TextEditingController _idPersonaController = TextEditingController();
  final TextEditingController _idSucursalController = TextEditingController();
  final TextEditingController _fechaContratacionController =
      TextEditingController();
  final TextEditingController _idPuestoController = TextEditingController();
  final TextEditingController _idStatusEmpleadoController =
      TextEditingController();
  final TextEditingController _ingresoSueldoBaseController =
      TextEditingController();
  final TextEditingController _ingresoBonificacionDecretoController =
      TextEditingController();
  final TextEditingController _ingresoOtrosIngresosController =
      TextEditingController();
  final TextEditingController _descuentoIgssController =
      TextEditingController();
  final TextEditingController _decuentoISRController = TextEditingController();
  final TextEditingController _descuentoInasistenciasController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<EmployeeBloc>().add(
          Employee(),
        );
    context.read<EmployeeBloc>().add(
          Person(),
        );
    context.read<EmployeeBloc>().add(
          Branch(),
        );
    context.read<EmployeeBloc>().add(
          Position(),
        );
    context.read<EmployeeBloc>().add(
          Status(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<EmployeeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is EmployeeSuccess) {
          setState(() {
            employees = state.employeeResponse.employees;
          });
        } else if (state is PersonSuccess) {
          setState(() {
            person = state.personResponse.users;
            dropdownValue = state.personResponse.users[0];
          });
        } else if (state is BranchSuccess) {
          setState(() {
            branch = state.branchResponse.branches;
            dropdownValueBranch = state.branchResponse.branches[0];
          });
        } else if (state is PositionSuccess) {
          setState(() {
            position = state.positionResponse.positions;
            dropdownValuePosition = state.positionResponse.positions[0];
          });
        } else if (state is StatusSuccess) {
          setState(() {
            status = state.statusResponse.statusList;
            dropdownValueStatus = state.statusResponse.statusList[0];
          });
        } else if (state is EmployeeEditSuccess) {
          context.read<EmployeeBloc>().add(
                Employee(),
              );
          context.read<EmployeeBloc>().add(
                Person(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado el empleado con éxito',
              ),
            ),
          );
        } else if (state is EmployeeCreateSuccess) {
          context.read<EmployeeBloc>().add(
                Employee(),
              );
          context.read<EmployeeBloc>().add(
                Person(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado el empleado con éxito',
              ),
            ),
          );
        } else if (state is EmployeeDeleteSuccess) {
          context.read<EmployeeBloc>().add(
                Employee(),
              );
          context.read<EmployeeBloc>().add(
                Person(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado el empleado con éxito',
              ),
            ),
          );
        } else if (state is EmployeeError) {
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
                        'Empleados',
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
                          _idPersonaController.text = '';
                          _idSucursalController.text = '';
                          _fechaContratacionController.text = '';
                          _idPuestoController.text = '';
                          _idStatusEmpleadoController.text = '';
                          _ingresoSueldoBaseController.text = '';
                          _ingresoBonificacionDecretoController.text = '';
                          _ingresoOtrosIngresosController.text = '';
                          _descuentoIgssController.text = '';
                          _decuentoISRController.text = '';
                          _descuentoInasistenciasController.text = '';
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
                            itemCount: employees.length,
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
                                        'Persona:  ${person.firstWhere((objeto) => objeto.idPersona == employees[index].idPersona).nombre}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Text(
                                            'Ingreso sueldo base:   ${employees[index].ingresoSueldoBase}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Fecha contratacion:   ${employees[index].fechaContratacion}',
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
                                                  dropdownValueBranch = branch
                                                      .firstWhere((objeto) =>
                                                          objeto.idBranch ==
                                                          employees[index]
                                                              .idSucursal);
                                                  _fechaContratacionController
                                                          .text =
                                                      employees[index]
                                                          .fechaContratacion;
                                                  dropdownValuePosition =
                                                      position.firstWhere(
                                                          (objeto) =>
                                                              objeto.idPuesto ==
                                                              employees[index]
                                                                  .idPuesto);
                                                  dropdownValueStatus = status
                                                      .firstWhere((objeto) =>
                                                          objeto
                                                              .idStatusEmpleado ==
                                                          employees[index]
                                                              .idStatusEmpleado);
                                                  _ingresoSueldoBaseController
                                                          .text =
                                                      employees[index]
                                                          .ingresoSueldoBase;
                                                  _ingresoBonificacionDecretoController
                                                      .text = employees[
                                                          index]
                                                      .ingresoBonificacionDecreto;
                                                  _ingresoOtrosIngresosController
                                                          .text =
                                                      employees[index]
                                                          .ingresoOtrosIngresos;
                                                  _descuentoIgssController
                                                          .text =
                                                      employees[index]
                                                          .descuentoIgss;
                                                  _decuentoISRController.text =
                                                      employees[index]
                                                          .descuentoIsr;
                                                  _descuentoInasistenciasController
                                                      .text = employees[
                                                          index]
                                                      .descuentoInasistencias;
                                                });
                                                _dialogEdit(
                                                  employees[index],
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
                                                  EmployeeDelete(
                                                    id: employees[index]
                                                        .idPersona,
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
          BlocBuilder<EmployeeBloc, BaseState>(
            builder: (context, state) {
              if (state is EmployeeInProgress) {
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
    final model.Employee employee,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Empleado'),
          content: SingleChildScrollView(
            child: Container(
              width: 800,
              height: 800,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton2<model.Branch>(
                    value: dropdownValueBranch,
                    items: branch.map((company) {
                      return DropdownMenuItem<model.Branch>(
                        value: company,
                        child: Text(company.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValueBranch = value!;
                      });
                    },
                  ),
                  TextField(
                    controller: _fechaContratacionController,
                    decoration: InputDecoration(labelText: 'FechaContratacion'),
                  ),
                  DropdownButton2<model.Position>(
                    value: dropdownValuePosition,
                    items: position.map((company) {
                      return DropdownMenuItem<model.Position>(
                        value: company,
                        child: Text(company.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValuePosition = value!;
                      });
                    },
                  ),
                  DropdownButton2<model.Status>(
                    value: dropdownValueStatus,
                    items: status.map((company) {
                      return DropdownMenuItem<model.Status>(
                        value: company,
                        child: Text(company.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValueStatus = value!;
                      });
                    },
                  ),
                  TextField(
                    controller: _ingresoSueldoBaseController,
                    decoration: InputDecoration(labelText: 'IngresoSueldoBase'),
                  ),
                  TextField(
                    controller: _ingresoBonificacionDecretoController,
                    decoration: InputDecoration(
                        labelText: 'IngresoBonificacionDecreto'),
                  ),
                  TextField(
                    controller: _ingresoOtrosIngresosController,
                    decoration:
                        InputDecoration(labelText: 'IngresoOtrosIngresos'),
                  ),
                  TextField(
                    controller: _descuentoIgssController,
                    decoration: InputDecoration(labelText: 'DescuentoIgss'),
                  ),
                  TextField(
                    controller: _decuentoISRController,
                    decoration: InputDecoration(labelText: 'DecuentoISR'),
                  ),
                  TextField(
                    controller: _descuentoInasistenciasController,
                    decoration:
                        InputDecoration(labelText: 'DescuentoInasistencias'),
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
              child: Text('Guardar'),
              onPressed: () {
                bloc.add(
                  EmployeeEdit(
                    idPersona: employee.idPersona,
                    idSucursal: _idSucursalController.text,
                    fechaContratacion: _fechaContratacionController.text,
                    idPuesto: _idPuestoController.text,
                    idStatusEmpleado: _idStatusEmpleadoController.text,
                    ingresoSueldoBase: _ingresoSueldoBaseController.text,
                    ingresoBonificacionDecreto:
                        _ingresoBonificacionDecretoController.text,
                    ingresoOtrosIngresos: _ingresoOtrosIngresosController.text,
                    descuentoIgss: _descuentoIgssController.text,
                    decuentoISR: _decuentoISRController.text,
                    descuentoInasistencias:
                        _descuentoInasistenciasController.text,
                    usuarioCreacion: employee.usuarioCreacion,
                    idEmpleado: employee.idEmpleado,
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
          title: Text('Crear Empleado'),
          content: SingleChildScrollView(
            child: Container(
              width: 800,
              height: 800,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton2<model.Person>(
                    value: dropdownValue,
                    items: person.map((company) {
                      return DropdownMenuItem<model.Person>(
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
                  DropdownButton2<model.Branch>(
                    value: dropdownValueBranch,
                    items: branch.map((company) {
                      return DropdownMenuItem<model.Branch>(
                        value: company,
                        child: Text(company.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValueBranch = value!;
                      });
                    },
                  ),
                  TextField(
                    controller: _fechaContratacionController,
                    decoration: InputDecoration(labelText: 'FechaContratacion'),
                  ),
                  DropdownButton2<model.Position>(
                    value: dropdownValuePosition,
                    items: position.map((company) {
                      return DropdownMenuItem<model.Position>(
                        value: company,
                        child: Text(company.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValuePosition = value!;
                      });
                    },
                  ),
                  DropdownButton2<model.Status>(
                    value: dropdownValueStatus,
                    items: status.map((company) {
                      return DropdownMenuItem<model.Status>(
                        value: company,
                        child: Text(company.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValueStatus = value!;
                      });
                    },
                  ),
                  TextField(
                    controller: _ingresoSueldoBaseController,
                    decoration: InputDecoration(labelText: 'IngresoSueldoBase'),
                  ),
                  TextField(
                    controller: _ingresoBonificacionDecretoController,
                    decoration: InputDecoration(
                        labelText: 'IngresoBonificacionDecreto'),
                  ),
                  TextField(
                    controller: _ingresoOtrosIngresosController,
                    decoration:
                        InputDecoration(labelText: 'IngresoOtrosIngresos'),
                  ),
                  TextField(
                    controller: _descuentoIgssController,
                    decoration: InputDecoration(labelText: 'DescuentoIgss'),
                  ),
                  TextField(
                    controller: _decuentoISRController,
                    decoration: InputDecoration(labelText: 'DecuentoISR'),
                  ),
                  TextField(
                    controller: _descuentoInasistenciasController,
                    decoration:
                        InputDecoration(labelText: 'DescuentoInasistencias'),
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
                  EmployeeCreate(
                    idPersona: _idPersonaController.text,
                    idSucursal: _idSucursalController.text,
                    fechaContratacion: _fechaContratacionController.text,
                    idPuesto: _idPuestoController.text,
                    idStatusEmpleado: _idStatusEmpleadoController.text,
                    ingresoSueldoBase: _ingresoSueldoBaseController.text,
                    ingresoBonificacionDecreto:
                        _ingresoBonificacionDecretoController.text,
                    ingresoOtrosIngresos: _ingresoOtrosIngresosController.text,
                    descuentoIgss: _descuentoIgssController.text,
                    decuentoISR: _decuentoISRController.text,
                    descuentoInasistencias:
                        _descuentoInasistenciasController.text,
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
    final name = await userRepository.getName();
    setState(() {
      this.name = name;
    });
  }
}
