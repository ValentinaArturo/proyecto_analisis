import 'package:flutter/material.dart';
import 'package:proyecto_analisis/common/components/side_menu.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/rol/model/menu.dart';

import '../../common/components/header.dart';
import '../../common/components/my_fields.dart';
import '../../common/components/recent_files.dart';
import '../../common/components/storage_details.dart';
import '../../common/responsive.dart';
import '../../resources/constants.dart';

class DashboardBody extends StatefulWidget {
  final Menu menu;

  const DashboardBody({super.key, required this.menu});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  late String name;

  @override
  void initState() {
    super.initState();
    name = '';
    _getName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(
        menu: widget.menu,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // We want this side menu only for large screen
          if (Responsive.isDesktop(context))
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: SideMenu(
                menu: widget.menu,
              ),
            ),
          Expanded(
            // It takes 5/6 part of the screen
            flex: 5,
            child: SafeArea(
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
                              if (Responsive.isMobile(context))
                                StorageDetails(),
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
}
