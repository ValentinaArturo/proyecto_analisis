part of 'bank_bloc.dart';

abstract class BankEvent {}

class GetBank extends BankEvent {}

class EditBank extends BankEvent {
  final String nombre;
  final String idUsuarioModificacion;

  final int idBank;

  EditBank({
    required this.idBank,
    required this.nombre,
    required this.idUsuarioModificacion,
  });
}

class CreateBank extends BankEvent {
  final String nombre;
  final String idUsuarioModificacion;

  CreateBank({
    required this.nombre,
    required this.idUsuarioModificacion,
  });
}

class DeleteBank extends BankEvent {
  final String idBank;

  DeleteBank({
    required this.idBank,
  });
}
