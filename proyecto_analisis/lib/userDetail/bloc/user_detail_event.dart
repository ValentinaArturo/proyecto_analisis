part of 'user_detail_bloc.dart';

abstract class UserDetailEvent {
  const UserDetailEvent();
}

class UserDetail extends UserDetailEvent {
  final String email;
  final String name;
  final String lastName;
  final int genre;
  final String birthDate;
  final String phone;
  final String idSucursal;
  final String nameCreate;
  final String idUsuario;
  final String idStatusUsuario;

  const UserDetail({
    required this.email,
    required this.name,
    required this.lastName,
    required this.genre,
    required this.birthDate,
    required this.phone,
    required this.idSucursal,
    required this.nameCreate,
    required this.idUsuario,
    required this.idStatusUsuario,
  });
}

class Genre extends UserDetailEvent {}

class Question extends UserDetailEvent {}

class Status extends UserDetailEvent {}

class Branch extends UserDetailEvent {}
