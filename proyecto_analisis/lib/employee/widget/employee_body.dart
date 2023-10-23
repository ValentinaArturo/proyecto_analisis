import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/employee/bloc/employee_bloc.dart';
import 'package:proyecto_analisis/employee/model/employee.dart' as model;
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class EmployeeBody extends StatefulWidget {
  const EmployeeBody({Key? key}) : super(key: key);

  @override
  State<EmployeeBody> createState() => _EmployeeBodyState();
}

class _EmployeeBodyState extends State<EmployeeBody> with ErrorHandling {
  List<model.Employee> employees = [];
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
        } else if (state is EmployeeEditSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado el empleado con éxito',
              ),
            ),
          );
        } else if (state is EmployeeCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado el empleado con éxito',
              ),
            ),
          );
        } else if (state is EmployeeDeleteSuccess) {
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
                                        'Persona:   ${employees[index].idPersona} ${employees[index].idEmpleado}',
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
                                                  _idPersonaController.text =
                                                      employees[index]
                                                          .idPersona;
                                                  _idSucursalController.text =
                                                      employees[index]
                                                          .idSucursal;
                                                  _fechaContratacionController
                                                          .text =
                                                      employees[index]
                                                          .fechaContratacion;
                                                  _idPuestoController.text =
                                                      employees[index].idPuesto;
                                                  _idStatusEmpleadoController
                                                          .text =
                                                      employees[index]
                                                          .idStatusEmpleado;
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _idPersonaController,
                decoration: InputDecoration(labelText: 'IdPersona'),
              ),
              TextField(
                controller: _idSucursalController,
                decoration: InputDecoration(labelText: 'IdSucursal'),
              ),
              TextField(
                controller: _fechaContratacionController,
                decoration: InputDecoration(labelText: 'FechaContratacion'),
              ),
              TextField(
                controller: _idPuestoController,
                decoration: InputDecoration(labelText: 'IdPuesto'),
              ),
              TextField(
                controller: _idStatusEmpleadoController,
                decoration: InputDecoration(labelText: 'IdStatusEmpleado'),
              ),
              TextField(
                controller: _ingresoSueldoBaseController,
                decoration: InputDecoration(labelText: 'IngresoSueldoBase'),
              ),
              TextField(
                controller: _ingresoBonificacionDecretoController,
                decoration:
                    InputDecoration(labelText: 'IngresoBonificacionDecreto'),
              ),
              TextField(
                controller: _ingresoOtrosIngresosController,
                decoration: InputDecoration(labelText: 'IngresoOtrosIngresos'),
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
                    usuarioCreacion: employee.usuarioCreacion,
                    idEmpleado: employee.idEmpleado,
                  ),
                );
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
          content: IntrinsicHeight(
            child: Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _idPersonaController,
                    decoration: InputDecoration(labelText: 'IdPersona'),
                  ),
                  TextField(
                    controller: _idSucursalController,
                    decoration: InputDecoration(labelText: 'IdSucursal'),
                  ),
                  TextField(
                    controller: _fechaContratacionController,
                    decoration: InputDecoration(labelText: 'FechaContratacion'),
                  ),
                  TextField(
                    controller: _idPuestoController,
                    decoration: InputDecoration(labelText: 'IdPuesto'),
                  ),
                  TextField(
                    controller: _idStatusEmpleadoController,
                    decoration: InputDecoration(labelText: 'IdStatusEmpleado'),
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
