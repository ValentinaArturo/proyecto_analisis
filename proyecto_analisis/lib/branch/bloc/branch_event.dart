part of 'branch_bloc.dart';

abstract class BranchEvent {}

class Branch extends BranchEvent {}

class BranchEdit extends BranchEvent {
  final String id;
  final String idBranch;
  final String nombre;
  final String direccion;
  final String idEmpresa;
  final String usuarioCreacion;

  BranchEdit({
    required this.id,
    required this.idBranch,
    required this.nombre,
    required this.direccion,
    required this.idEmpresa,
    required this.usuarioCreacion,
  });
}

class BranchCreate extends BranchEvent {
  final String id;
  final String nombre;
  final String direccion;
  final String idEmpresa;
  final String usuarioCreacion;

  BranchCreate({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.idEmpresa,
    required this.usuarioCreacion,
  });
}

class BranchDelete extends BranchEvent {
  final String idBranch;

  BranchDelete({
    required this.idBranch,
  });
}
