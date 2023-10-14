import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_analisis/common/components/header.dart';
import 'package:proyecto_analisis/common/components/my_files.dart';
import 'package:proyecto_analisis/common/components/recent_files.dart';
import 'package:proyecto_analisis/common/components/storage_details.dart';
import 'package:proyecto_analisis/genres/genres_screen.dart';
import 'package:proyecto_analisis/modules/modules_screen.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/rol/model/menu.dart';
import 'package:proyecto_analisis/rolrol/rolrol_screen.dart';
import 'package:proyecto_analisis/rols/rols_screen.dart';
import 'package:proyecto_analisis/rolsUser/rols_user_screen.dart';

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

  Widget _dashBoard() {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              name: name,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      const MyFiles(),
                      const SizedBox(height: defaultPadding),
                      const RecentFiles(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) const StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  const Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _getMenuWidgets() {
    List<Widget> myWidgets = widget.menu.options.map((obj) {
      if (obj.nombre == 'Empresas') {
        return _dashBoard();
      } else if (obj.nombre == 'Sucursales') {
        return Container(
          child: const Text('Sucursales'),
        );
      } else if (obj.nombre == 'Generos') {
        return GenresScreen();
      } else if (obj.nombre == 'Estatus Usuario') {
        return Container(
          child: const Text('Estatus Usuario'),
        );
      } else if (obj.nombre == 'Roles') {
        return RolRolScreen();
      } else if (obj.nombre == 'Modulos') {
        return ModulesScreen();
      } else if (obj.nombre == 'Menus') {
        return Container(
          child: const Text('Menus'),
        );
      } else if (obj.nombre == 'Opciones') {
        return Container(
          child: const Text('Opciones'),
        );
      } else if (obj.nombre == 'Usuarios') {
        return const RolsScreen();
      } else if (obj.nombre == 'Asignar Roles a un Usuario') {
        return const RolsUserScreen();
      } else if (obj.nombre == 'Asignar Opciones a un Role') {
        return Container(
          child: const Text('Asignar Opciones a un Role'),
        );
      } else if (obj.nombre == 'Estados Civiles') {
        return Container(
          child: const Text('Estados Civiles'),
        );
      } else if (obj.nombre == 'Status Empleado') {
        return Container(
          child: const Text('Status Empleado'),
        );
      } else if (obj.nombre == 'Flujos Status Empleado') {
        return Container(
          child: const Text('Flujos Status Empleado'),
        );
      } else if (obj.nombre == 'Tipos de Documento') {
        return Container(
          child: const Text('Tipos de Documento'),
        );
      } else if (obj.nombre == 'Departamentos') {
        return Container(
          child: const Text('Departamentos'),
        );
      } else if (obj.nombre == 'Puestos') {
        return Container(
          child: const Text('Puestos'),
        );
      } else if (obj.nombre == 'Personas') {
        return Container(
          child: const Text('Personas'),
        );
      } else if (obj.nombre == 'Documentos de Personas') {
        return Container(
          child: const Text('Documentos de Personas'),
        );
      } else if (obj.nombre == 'Bancos') {
        return Container(
          child: const Text('Bancos'),
        );
      } else if (obj.nombre == 'Empleados') {
        return Container(
          child: const Text('Empleados'),
        );
      }
      return Text(obj.nombre);
    }).toList();

    return myWidgets;
  }
}
