abstract class SignUpEvent {
  const SignUpEvent();
}

class SignUp extends SignUpEvent {
  final String password;
  final String email;
  final String name;
  final String lastName;
  final int genre;
  final String birthDate;
  final String phone;
  final String id1;
  final String id2;
  final String id3;
  final String q1;
  final String q2;
  final String q3;

  const SignUp({
    required this.email,
    required this.password,
    required this.name,
    required this.lastName,
    required this.genre,
    required this.birthDate,
    required this.phone,
    required this.id1,
    required this.id2,
    required this.id3,
    required this.q1,
    required this.q2,
    required this.q3,
  });
}

class Genre extends SignUpEvent {}

class Question extends SignUpEvent {}
