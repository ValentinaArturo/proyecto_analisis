part of 'branch_bloc.dart';

abstract class BranchState extends BaseState {}

class BranchInitial extends BranchState {}

class BranchInProgress extends BranchState {}

class BranchSuccess extends BranchState {
  final BranchResponse branchResponse;

  BranchSuccess({
    required this.branchResponse,
  });
}

class BranchEditSuccess extends BranchState {}

class BranchCreateSuccess extends BranchState {}

class BranchDeleteSuccess extends BranchState {}

class BranchError extends BranchState {
  final String? error;

  BranchError(
      this.error,
      );
}
class CompanySuccess extends BranchState {
  final CompanyResponse companyResponse;

  CompanySuccess({
    required this.companyResponse,
  });
}
