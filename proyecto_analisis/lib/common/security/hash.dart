import 'dart:convert';

import 'package:crypto/crypto.dart';

class Hash {
  static String hash(String toHash) {
    final bytesToHash = utf8.encode(toHash);
    final hashInput = sha512.convert(bytesToHash);

    return base64Encode(hashInput.bytes);
  }
}
