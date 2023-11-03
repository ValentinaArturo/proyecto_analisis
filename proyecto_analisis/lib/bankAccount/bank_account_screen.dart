import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/bankAccount/bloc/bank_account_bloc.dart';
import 'package:proyecto_analisis/bankAccount/service/bank_account_service.dart';
import 'package:proyecto_analisis/bankAccount/widget/bank_account_body.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BankAccountScreen extends StatefulWidget {
  const BankAccountScreen({Key? key}) : super(key: key);

  @override
  _BankAccountScreenState createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BankAccountBloc(
        service: BankAccountService(),
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
          desktop: (context) => const BankAccountBody(),
          mobile: (context) => const BankAccountBody(),
        ),
      ),
    );
  }
}
