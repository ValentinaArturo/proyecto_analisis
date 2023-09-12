abstract class LoginEvent {
  const LoginEvent();
}


class LoginWithEmailPassword extends LoginEvent {
  final String email;
  final String password;

  const LoginWithEmailPassword({
    required this.email,
    required this.password,
  });
}
