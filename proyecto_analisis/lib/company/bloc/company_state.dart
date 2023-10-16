import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/company/model/company.dart';

abstract class CompanyState extends BaseState {}

class CompanyInitial extends CompanyState {}

class CompanyInProgress extends CompanyState {}

class CompanySuccess extends CompanyState {
  final CompanyResponse companyResponse;

  CompanySuccess({
    required this.companyResponse,
  });
}

class CompanyEditSuccess extends CompanyState {}

class CompanyCreateSuccess extends CompanyState {}

class CompanyDeleteSuccess extends CompanyState {}

class CompanyError extends CompanyState {
  final String? error;

  CompanyError(
    this.error,
  );
}
