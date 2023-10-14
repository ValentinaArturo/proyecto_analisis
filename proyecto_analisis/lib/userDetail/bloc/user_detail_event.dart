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


  const UserDetail({
    required this.email,
    required this.name,
    required this.lastName,
    required this.genre,
    required this.birthDate,
    required this.phone,
  });
}

class Genre extends UserDetailEvent {}

class Question extends UserDetailEvent {}
