import 'package:flutter/material.dart';
import 'package:proyecto_analisis/common/textField/input.dart';

class SecurityQuestionsBody extends StatefulWidget {
  const SecurityQuestionsBody({super.key});

  @override
  State<SecurityQuestionsBody> createState() => _SecurityQuestionsBodyState();
}

class _SecurityQuestionsBodyState extends State<SecurityQuestionsBody> {
  TextEditingController firstQuestion = TextEditingController();
  TextEditingController secondQuestion = TextEditingController();
  TextEditingController thirdQuestion = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(),
          Container(
            padding: const EdgeInsets.only(left: 35, top: 100),
            child: const Text(
              'Preguntas de seguridad',
              style: TextStyle(color: Colors.white, fontSize: 43),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 235, right: 235),
                      child: Column(
                        children: [
                          CustomInput(
                            controller: firstQuestion,
                            label: "1. Pregunta de seguridad",
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomInput(
                            controller: secondQuestion,
                            label: "2. Pregunta de seguridad",
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomInput(
                            controller: thirdQuestion,
                            label: "3. Pregunta de seguridad",
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'Continuar',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      //login();
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
          ),
        ],
      ),
    );
  }
}
