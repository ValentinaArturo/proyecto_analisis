import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/typeDocument/bloc/type_document_bloc.dart';
import 'package:proyecto_analisis/typeDocument/service/type_document_service.dart';
import 'package:proyecto_analisis/typeDocument/widget/type_document_body.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TypeDocumentScreen extends StatefulWidget {
  const TypeDocumentScreen({Key? key}) : super(key: key);

  @override
  _TypeDocumentScreenState createState() => _TypeDocumentScreenState();
}

class _TypeDocumentScreenState extends State<TypeDocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TypeDocumentBloc(
        service: TypeDocumentService(),
        userRepository: UserRepository(),
      ),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/register.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: ScreenTypeLayout.builder(
          desktop: (context) => const TypeDocumentBody(),
          mobile: (context) => const TypeDocumentBody(),
        ),
      ),
    );
  }
}
