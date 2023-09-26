class Encrypt {
  static String encryptPassword(
    String password,
  ) {
    String combinedString = '${password}8534f3c6-7a85-4baf-a773-d4801a1232bf';

    String encryptedPassword = '';

    for (int i = 0; i < combinedString.length; i++) {
      encryptedPassword +=
          String.fromCharCode(combinedString.codeUnitAt(i) + 1);
    }

    return encryptedPassword;
  }
}
