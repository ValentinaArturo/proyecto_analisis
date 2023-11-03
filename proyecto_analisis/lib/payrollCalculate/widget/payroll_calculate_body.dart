import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/payloadReport/bloc/payroll_report_bloc.dart';
import 'package:proyecto_analisis/payloadReport/model/payroll_response.dart'
    as model;
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class PayrollCalculateBody extends StatefulWidget {
  const PayrollCalculateBody({Key? key}) : super(key: key);

  @override
  State<PayrollCalculateBody> createState() => _PayrollCalculateBodyState();
}

class _PayrollCalculateBodyState extends State<PayrollCalculateBody>
    with ErrorHandling {
  List<model.Detalle> payrollReports = [];
  List<model.Cabecera> payrollReportsHeader = [];

  late PayrollReportBloc bloc;
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<PayrollReportBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PayrollReportBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is PayrollReportSuccess) {
          setState(() {
            payrollReports = state.detalle;
            payrollReportsHeader = state.cabecera;
          });
        } else if (state is PayrollReportCreateSuccess) {
          bloc.add(
            PayrollReport(
              year: int.parse(_yearController.text),
              month: int.parse(_monthController.text),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado el informe de nómina con éxito',
              ),
            ),
          );
        } else if (state is PayrollReportError) {
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
                        'Informes de Nómina',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _yearController.text = '';
                              _monthController.text = '';
                            });

                            _dialogCreate();
                          },
                          child: const Icon(
                            Icons.add,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    payrollReportsHeader.isNotEmpty
                        ? ListTile(
                      leading: const Icon(
                        Icons.table_chart,
                        color: Colors.purpleAccent,
                      ),
                      title: Text(
                        'Año:   ${payrollReportsHeader[0].anio}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Mes:   ${payrollReportsHeader[0].mes}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Salrio neto:   ${payrollReportsHeader[0].salarioNeto}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total descuentos:   ${payrollReportsHeader[0].totalDescuentos}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total ingresos:   ${payrollReportsHeader[0].totalIngresos}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(),
                    Expanded(
                      child: Card(
                        color: bgColor,
                        child: Container(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.05,
                          ),
                          child: ListView.builder(
                            itemCount: payrollReports.length,
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
                                        'Nombre:   ${payrollReports[index].nombreEmpleado}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Puesto:   ${payrollReports[index].puesto}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Salrio neto:   ${payrollReports[index].salarioNeto}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Sueldo Base:   ${payrollReports[index].ingresoSueldoBase}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Otros ingresos:   ${payrollReports[index].ingresoOtrosIngresos}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Bonificacion:   ${payrollReports[index].ingresoBonificacionDecreto}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Decuento ISR:   ${payrollReports[index].descuentoIsr}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Decuento IGSS:   ${payrollReports[index].descuentoIgss}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Decuento Inasistencias:   ${payrollReports[index].descuentoInasistencias}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
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
          BlocBuilder<PayrollReportBloc, BaseState>(
            builder: (context, state) {
              if (state is PayrollReportInProgress) {
                return const Loader();
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  _dialogShow() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            title: Text('Mostrar Informe de Nómina'),
            content: IntrinsicHeight(
              child: Container(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _yearController,
                      decoration: InputDecoration(labelText: 'Año'),
                    ),
                    TextField(
                      controller: _monthController,
                      decoration: InputDecoration(labelText: 'Mes'),
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
                child: Text('Ver'),
                onPressed: () {
                  bloc.add(
                    PayrollReport(
                      year: int.parse(_yearController.text),
                      month: int.parse(_monthController.text),
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

  _dialogCreate() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            title: Text('Crear Informe de Nómina'),
            content: IntrinsicHeight(
              child: Container(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _yearController,
                      decoration: InputDecoration(labelText: 'Año'),
                    ),
                    TextField(
                      controller: _monthController,
                      decoration: InputDecoration(labelText: 'Mes'),
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
                    PayrollReportCreate(
                      year: int.parse(_yearController.text),
                      month: int.parse(_monthController.text),
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
}
