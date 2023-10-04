import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_analisis/common/components/header.dart';
import 'package:proyecto_analisis/common/components/my_files.dart';
import 'package:proyecto_analisis/common/components/recent_files.dart';
import 'package:proyecto_analisis/common/components/storage_details.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/rol/model/menu.dart';
import 'package:proyecto_analisis/rols/rols_screen.dart';

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
            decoration: BoxDecoration(),
            openSideMenuWidth: 200,
            compactSideMenuWidth: 40,
            hoverColor: Colors.blue[100],
            selectedColor: Colors.lightBlue,
            selectedIconColor: Colors.white,
            unselectedIconColor: Colors.black54,
            backgroundColor: Colors.grey,
            selectedTitleTextStyle: TextStyle(color: Colors.white),
            unselectedTitleTextStyle: TextStyle(color: Colors.black54),
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
                  decoration: BoxDecoration(),
                  openSideMenuWidth: 200,
                  compactSideMenuWidth: 40,
                  hoverColor: Colors.blue[100],
                  selectedColor: secondaryColor,
                  selectedIconColor: Colors.white,
                  unselectedIconColor: Colors.black54,
                  backgroundColor: bgColor,
                  selectedTitleTextStyle: TextStyle(color: Colors.white),
                  unselectedTitleTextStyle: TextStyle(color: Colors.black54),
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
              physics: NeverScrollableScrollPhysics(),
              children: [
                _dashBoard(),
                RolsScreen(),
                RolsScreen(),
              ],
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
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              name: name,
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      MyFiles(),
                      SizedBox(height: defaultPadding),
                      RecentFiles(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
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
}
