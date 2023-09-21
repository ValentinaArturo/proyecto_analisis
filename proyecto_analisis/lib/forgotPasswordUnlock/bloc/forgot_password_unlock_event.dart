abstract class ForgotPasswordUnlockEvent {
  const ForgotPasswordUnlockEvent();
}

class ForgotPasswordUnlock extends ForgotPasswordUnlockEvent {
  final String newPassword;
  final String email;
  final String id1;
  final String id2;
  final String id3;
  final String q1;
  final String q2;
  final String q3;

  const ForgotPasswordUnlock({
    required this.email,
    required this.newPassword,
    required this.id1,
    required this.id2,
    required this.id3,
    required this.q1,
    required this.q2,
    required this.q3,
  });
}
