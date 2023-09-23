import 'package:flutter/material.dart';
import 'package:proyecto_analisis/routes/landing_routes_constants.dart';

class AccessDeniedBody extends StatefulWidget {
  const AccessDeniedBody({super.key});

  @override
  State<AccessDeniedBody> createState() => _AccessDeniedBodyState();
}

class _AccessDeniedBodyState extends State<AccessDeniedBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 35,
              top: 100,
            ),
            child: const Text(
              'Acceso Denegado',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 43,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 35,
                      right: 35,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 150,
                          child: Icon(
                            Icons.block,
                            color: Colors.grey,
                            size: 150,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          'Tu usuario se encuentra bloqueado,\n para poder acceder debes\n cambiar tu contraseña.',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: const Text(
                                'Continuar',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xff4c505b),
                              child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      forgotPasswordExpiredRoute,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
