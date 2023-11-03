import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/employee/model/employee.dart' as model;
import 'package:proyecto_analisis/notAttendance/bloc/not_assistance_bloc.dart';
import 'package:proyecto_analisis/notAttendance/model/not_attendance_response.dart'
    as model;
import 'package:proyecto_analisis/person/model/person.dart' as model;
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class NotAssistanceBody extends StatefulWidget {
  const NotAssistanceBody({Key? key}) : super(key: key);

  @override
  State<NotAssistanceBody> createState() => _NotAssistanceBodyState();
}

class _NotAssistanceBodyState extends State<NotAssistanceBody>
    with ErrorHandling {
  List<model.NotAssitance> notAssistanceList = [];
  late NotAssistanceBloc bloc;
  late String name;
  final TextEditingController _dateInit = TextEditingController();
  final TextEditingController _dateFinal = TextEditingController();
  final TextEditingController _motive = TextEditingController();

  List<model.Employee> employees = [];
  late model.Employee dropdownValue;
  List<model.Person> person = [];

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<NotAssistanceBloc>().add(
          GetNotAssistance(),
        );
    context.read<NotAssistanceBloc>().add(
          Employee(),
        );
    context.read<NotAssistanceBloc>().add(
          Person(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<NotAssistanceBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotAssistanceBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is NotAssistanceSuccess) {
          setState(() {
            notAssistanceList = state.success.notassitances;
          });
        } else if (state is PersonSuccess) {
          setState(() {
            person = state.personResponse.users;
          });
        } else if (state is EmployeeSuccess) {
          setState(() {
            employees = state.employeeResponse.employees;
            dropdownValue = state.employeeResponse.employees[0];
          });
        } else if (state is NotAssistanceEditSuccess) {
          context.read<NotAssistanceBloc>().add(
                GetNotAssistance(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado la inasistencia con éxito',
              ),
            ),
          );
        } else if (state is NotAssistanceCreateSuccess) {
          context.read<NotAssistanceBloc>().add(
                GetNotAssistance(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado la inasistencia con éxito',
              ),
            ),
          );
        } else if (state is NotAssistanceDeleteSuccess) {
          context.read<NotAssistanceBloc>().add(
                GetNotAssistance(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado la inasistencia con éxito',
              ),
            ),
          );
        } else if (state is NotAssistanceError) {
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
                        'Not Assistance',
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
                          _dateInit.text = '';
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
                            itemCount: notAssistanceList.length,
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
                                        'Nombre:   ${person.firstWhere((objeto) => objeto.idPersona == employees.firstWhere((objeto) => objeto.idEmpleado == notAssistanceList[index].idEmpleado).idPersona).nombre}  ${person.firstWhere((objeto) => objeto.idPersona == employees.firstWhere((objeto) => objeto.idEmpleado == notAssistanceList[index].idEmpleado).idPersona).apellido}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Text(
                                            'Inasistencia:  ${notAssistanceList[index].fechaInicial} - ${notAssistanceList[index].fechaFinal}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Motivo:  ${notAssistanceList[index].motivoInasistencia}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
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
                                                  _dateInit.text =
                                                      notAssistanceList[index]
                                                          .fechaInicial;
                                                  _dateFinal.text =
                                                      notAssistanceList[index]
                                                          .fechaFinal;
                                                  _motive.text =
                                                      notAssistanceList[index]
                                                          .motivoInasistencia;
                                                });
                                                _dialogEdit(
                                                  notAssistanceList[index],
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
                                                  DeleteNotAssistance(
                                                    idNotAssistance:
                                                        notAssistanceList[index]
                                                            .idInasistencia,
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
          BlocBuilder<NotAssistanceBloc, BaseState>(
            builder: (context, state) {
              if (state is NotAssistanceInProgress) {
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
    final model.NotAssitance notAssistance,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Editar Not Assistance'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _dateInit,
                    decoration:
                        InputDecoration(labelText: 'Fecha Inicio DD-MM-YYYY'),
                  ),
                  TextField(
                    controller: _dateFinal,
                    decoration:
                        InputDecoration(labelText: 'Fecha final DD-MM-YYYY'),
                  ),
                  TextField(
                    controller: _motive,
                    decoration: InputDecoration(labelText: 'Motivo'),
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
                    String notAssistanceName = _dateInit.text;
                    bloc.add(
                      EditNotAssistance(
                        motivoInasistencia: _motive.text,
                        idEmpleado: int.parse(notAssistance.idEmpleado),
                        fechaProcesado:
                            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                        fechaInicial: _dateInit.text,
                        fechaFinal: _dateFinal.text,
                        idInasistencia: int.parse(notAssistance.idInasistencia),
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
            title: Text('Crear Not Assistance'),
            content: IntrinsicHeight(
              child: Container(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _dateInit,
                      decoration:
                          InputDecoration(labelText: 'Fecha Inicio DD-MM-YYYY'),
                    ),
                    TextField(
                      controller: _dateFinal,
                      decoration:
                          InputDecoration(labelText: 'Fecha final DD-MM-YYYY'),
                    ),
                    TextField(
                      controller: _motive,
                      decoration: InputDecoration(labelText: 'Motivo'),
                    ),
                    DropdownButton2<model.Employee>(
                      value: dropdownValue,
                      items: employees.map((company) {
                        return DropdownMenuItem<model.Employee>(
                          value: company,
                          child: Text(
                              '${person.firstWhere((objeto) => objeto.idPersona == company.idPersona).nombre} ${person.firstWhere((objeto) => objeto.idPersona == company.idPersona).apellido}'),
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
                  String notAssistanceName = _dateInit.text;
                  bloc.add(
                    CreateNotAssistance(
                      motivoInasistencia: _motive.text,
                      idEmpleado: int.parse(dropdownValue.idEmpleado),
                      fechaProcesado:
                          '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                      fechaInicial: _dateInit.text,
                      fechaFinal: _dateFinal.text,
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
