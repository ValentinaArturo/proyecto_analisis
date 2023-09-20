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

  const SignUp({
    required this.email,
    required this.password,
    required this.name,
    required this.lastName,
    required this.genre,
    required this.birthDate,
    required this.phone,
  });
}

class Genre extends SignUpEvent {}
