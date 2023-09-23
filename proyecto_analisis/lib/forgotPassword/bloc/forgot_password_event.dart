abstract class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

class ForgotPassword extends ForgotPasswordEvent {
  final String newPassword;
  final String oldPassword;

  const ForgotPassword({
    required this.newPassword,
    required this.oldPassword,
  });
}
