abstract class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

class ForgotPassword extends ForgotPasswordEvent {
  final String newPassword;
  final String oldPassword;
  final String email;

  const ForgotPassword({
    required this.email,
    required this.newPassword,
    required this.oldPassword,
  });
}
