import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_analisis/bank/bank_screen.dart';
import 'package:proyecto_analisis/bankAccount/bank_account_screen.dart';
import 'package:proyecto_analisis/branch/branch_screen.dart';
import 'package:proyecto_analisis/civilStatus/civil_status_screen.dart';
import 'package:proyecto_analisis/company/company_screen.dart';
import 'package:proyecto_analisis/department/department_screen.dart';
import 'package:proyecto_analisis/document/document_screen.dart';
import 'package:proyecto_analisis/employee/employee_screen.dart';
import 'package:proyecto_analisis/genres/genres_screen.dart';
import 'package:proyecto_analisis/menu/menu_screen.dart';
import 'package:proyecto_analisis/modules/modules_screen.dart';
import 'package:proyecto_analisis/notAttendance/not_attendance_screen.dart';
import 'package:proyecto_analisis/option/option_screen.dart';
import 'package:proyecto_analisis/payloadReport/payroll_report_screen.dart';
import 'package:proyecto_analisis/payrollCalculate/paylroll_calculate_screen.dart';
import 'package:proyecto_analisis/person/person_screen.dart';
import 'package:proyecto_analisis/position/position_screen.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/rol/model/menu.dart';
import 'package:proyecto_analisis/rolrol/rolrol_screen.dart';
import 'package:proyecto_analisis/rols/rols_screen.dart';
import 'package:proyecto_analisis/rolsUser/rols_user_screen.dart';
import 'package:proyecto_analisis/status/status_screen.dart';
import 'package:proyecto_analisis/statusUser/status_user_screen.dart';
import 'package:proyecto_analisis/typeDocument/type_document_screen.dart';

import '../../common/responsive.dart';

class DashboardBody extends StatefulWidget {
  final Menu menu;

  const DashboardBody({super.key, required this.menu});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  late String name;
  List<SideMenuItem> menu = [];
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    name = '';
    _getName();
    menu = widget.menu.options.asMap().entries.map((e) {
      return SideMenuItem(
        title: e.value.nombre,
        onTap: (index, controller) {
          pageController.jumpToPage(e.key);
        },
      );
    }).toList();
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.person,
        ),
        backgroundColor: primaryColor,
        elevation: 5,
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      drawer: SideMenu(
        controller: sideMenu,
        style: SideMenuStyle(
            displayMode: SideMenuDisplayMode.auto,
            decoration: const BoxDecoration(),
            openSideMenuWidth: 200,
            compactSideMenuWidth: 40,
            hoverColor: Colors.blue[100],
            selectedColor: Colors.lightBlue,
            selectedIconColor: Colors.white,
            unselectedIconColor: Colors.black54,
            backgroundColor: Colors.grey,
            selectedTitleTextStyle: const TextStyle(color: Colors.white),
            unselectedTitleTextStyle: const TextStyle(color: Colors.black54),
            iconSize: 20,
            itemBorderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            showTooltip: true,
            itemHeight: 50.0,
            itemInnerSpacing: 8.0,
            itemOuterPadding: const EdgeInsets.symmetric(horizontal: 5.0),
            toggleColor: Colors.black54),
        onDisplayModeChanged: (mode) {
          print(mode);
        },
        items: menu,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            Expanded(
              child: SideMenu(
                controller: sideMenu,
                style: SideMenuStyle(
                  displayMode: SideMenuDisplayMode.auto,
                  decoration: const BoxDecoration(),
                  openSideMenuWidth: 200,
                  compactSideMenuWidth: 40,
                  hoverColor: Colors.blue[100],
                  selectedColor: secondaryColor,
                  selectedIconColor: Colors.white,
                  unselectedIconColor: Colors.black54,
                  backgroundColor: bgColor,
                  selectedTitleTextStyle: const TextStyle(color: Colors.white),
                  unselectedTitleTextStyle:
                      const TextStyle(color: Colors.black54),
                  iconSize: 20,
                  itemBorderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  showTooltip: true,
                  itemHeight: 50.0,
                  itemInnerSpacing: 8.0,
                  itemOuterPadding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 5.0,
                  ),
                  toggleColor: Colors.black54,
                ),
                onDisplayModeChanged: (mode) {
                  print(mode);
                },
                items: menu,
              ),
            ),
          Expanded(
            flex: 5,
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _getMenuWidgets(),
            ),
          ),
        ],
      ),
    );
  }

  _getName() async {
    final UserRepository userRepository = UserRepository();
    final name = await userRepository.getName();
    setState(() {
      this.name = name;
    });
  }

  List<Widget> _getMenuWidgets() {
    List<Widget> myWidgets = widget.menu.options.map((obj) {
      if (obj.nombre == 'Empresas') {
        return const CompanyScreen();
      } else if (obj.nombre == 'Sucursales') {
        return BranchScreen();
      } else if (obj.nombre == 'Generos') {
        return const GenresScreen();
      } else if (obj.nombre == 'Estatus Usuario') {
        return StatusUserScreen();
      } else if (obj.nombre == 'Roles') {
        return const RolRolScreen();
      } else if (obj.nombre == 'Modulos') {
        return const ModulesScreen();
      } else if (obj.nombre == 'Menus') {
        return const MenuScreen();
      } else if (obj.nombre == 'Opciones') {
        return OptionScreen();
      } else if (obj.nombre == 'Usuarios') {
        return const RolsScreen();
      } else if (obj.nombre == 'Asignar Roles a un Usuario') {
        return const RolsUserScreen();
      } else if (obj.nombre == 'Asignar Opciones a un Role') {
        return Container(
          child: const Text('Asignar Opciones a un Role'),
        );
      } else if (obj.nombre == 'Estados Civiles') {
        return CivilStatusScreen();
      } else if (obj.nombre == 'Status Empleado') {
        return StatusScreen();
      } else if (obj.nombre == 'Flujos Status Empleado') {
        return Container(
          child: const Text('Flujos Status Empleado'),
        );
      } else if (obj.nombre == 'Tipos de Documentos') {
        return TypeDocumentScreen();
      } else if (obj.nombre == 'Departamentos') {
        return DepartmentScreen();
      } else if (obj.nombre == 'Puestos') {
        return PositionScreen();
      } else if (obj.nombre == 'Personas') {
        return PersonScreen();
      } else if (obj.nombre == 'Documentos de Personas') {
        return DocumentScreen();
      } else if (obj.nombre == 'Bancos') {
        return BankScreen();
      } else if (obj.nombre == 'Empleados') {
        return EmployeeScreen();
      } else if (obj.nombre == 'Calcular Planilla') {
        return PayrollCalculateScreen();
      } else if (obj.nombre == 'Reporte de Planilla') {
        return PayrollReportScreen();
      } else if (obj.nombre == 'Inasistencias de Empleados') {
        return NotAssistanceScreen();
      } else if (obj.nombre == 'Cuentas Bancarias Empleados') {
        return BankAccountScreen();
      }
      return Text(obj.nombre);
    }).toList();
    return myWidgets;
  }
}
