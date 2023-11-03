import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/bank/model/bank_response.dart' as model;
import 'package:proyecto_analisis/bankAccount/bloc/bank_account_bloc.dart';
import 'package:proyecto_analisis/bankAccount/model/bank_account_response.dart'
    as model;
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/employee/model/employee.dart' as model;
import 'package:proyecto_analisis/person/model/person.dart' as model;
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';

import '../../common/loader/loader.dart';

class BankAccountBody extends StatefulWidget {
  const BankAccountBody({Key? key}) : super(key: key);

  @override
  State<BankAccountBody> createState() => _BankAccountBodyState();
}

class _BankAccountBodyState extends State<BankAccountBody> with ErrorHandling {
  List<model.BankAccount> bankAccountList = [];
  late BankAccountBloc bloc;
  late String name;
  final TextEditingController _number = TextEditingController();
  final TextEditingController _active = TextEditingController();

  List<model.Employee> employees = [];
  List<model.Person> person = [];
  List<model.Bank> banks = [];
  late model.Employee dropdownValue;
  late model.Bank dropdownValueBank;

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<BankAccountBloc>().add(
          GetBankAccount(),
        );
    context.read<BankAccountBloc>().add(
          Employee(),
        );
    context.read<BankAccountBloc>().add(
          Person(),
        );
    context.read<BankAccountBloc>().add(
          GetBank(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<BankAccountBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BankAccountBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is BankAccountSuccess) {
          setState(() {
            bankAccountList = state.success.bank;
          });
        } else if (state is BankSuccess) {
          setState(() {
            banks = state.success.bank;
            dropdownValueBank = state.success.bank[0];
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
        } else if (state is BankAccountEditSuccess) {
          context.read<BankAccountBloc>().add(
                GetBankAccount(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text(
                state.msg,
              ),
            ),
          );
        } else if (state is BankAccountCreateSuccess) {
          context.read<BankAccountBloc>().add(
                GetBankAccount(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado la cuenta bancaria con éxito',
              ),
            ),
          );
        } else if (state is BankAccountDeleteSuccess) {
          context.read<BankAccountBloc>().add(
                GetBankAccount(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado la cuenta bancaria con éxito',
              ),
            ),
          );
        } else if (state is BankAccountError) {
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
                        'Bank Account',
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
                          _number.text = '';
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
                            itemCount: bankAccountList.length,
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
                                        'Nombre:   ${person.firstWhere((objeto) => objeto.idPersona == employees.firstWhere((objeto) => objeto.idEmpleado == bankAccountList[index].idEmpleado).idPersona).nombre}  ${person.firstWhere((objeto) => objeto.idPersona == employees.firstWhere((objeto) => objeto.idEmpleado == bankAccountList[index].idEmpleado).idPersona).apellido}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Text(
                                            'Cuenta Bancaria:  ${bankAccountList[index].numeroDeCuenta}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Estado:  ${bankAccountList[index].activa == '1' ? 'Activa' : 'Inactiva'}',
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
                                                  _number.text =
                                                      bankAccountList[index]
                                                          .numeroDeCuenta;
                                                  _active.text =
                                                      bankAccountList[index]
                                                          .activa;
                                                });
                                                _dialogEdit(
                                                  bankAccountList[index],
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
                                                  DeleteBankAccount(
                                                    idBankAccount:
                                                        bankAccountList[index]
                                                            .idCuentaBancaria,
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
          BlocBuilder<BankAccountBloc, BaseState>(
            builder: (context, state) {
              if (state is BankAccountInProgress) {
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
    final model.BankAccount bankAccount,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Editar Bank Account'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _number,
                    decoration: InputDecoration(labelText: 'Numero de cuenta'),
                  ),
                  TextField(
                    controller: _active,
                    decoration: InputDecoration(
                        labelText: 'Activar: 1 - Desactivar: 0'),
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
                      EditBankAccount(
                        idEmpleado: int.parse(bankAccount.idEmpleado),
                        numeroDeCuenta: _number.text,
                        idBanco: int.parse(bankAccount.idBanco),
                        activa: _active.text,
                        usuarioCreacion: name,
                        idCuentaBancaria:
                            int.parse(bankAccount.idCuentaBancaria),
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
            title: Text('Crear Bank Account'),
            content: IntrinsicHeight(
              child: Container(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _number,
                      decoration:
                          InputDecoration(labelText: 'Numero de cuenta'),
                    ),
                    TextField(
                      controller: _active,
                      decoration: InputDecoration(
                          labelText: 'Activar: 1 - Desactivar: 0'),
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
                    DropdownButton2<model.Bank>(
                      value: dropdownValueBank,
                      items: banks.map((company) {
                        return DropdownMenuItem<model.Bank>(
                          value: company,
                          child: Text(
                            company.nombre,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValueBank = value!;
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
                    CreateBankAccount(
                      idEmpleado: int.parse(dropdownValue.idEmpleado),
                      numeroDeCuenta: _number.text,
                      idBanco: int.parse(dropdownValueBank.idBanco),
                      activa: _active.text,
                      usuarioCreacion: name,
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
