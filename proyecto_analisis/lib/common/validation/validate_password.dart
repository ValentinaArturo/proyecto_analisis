import 'package:flutter/material.dart';

String? validatePassword(
  final String value,
  final BuildContext context,
) {
  if (value.length < 6) {
    return "Contraseña debe tener 6 o mas caracteres";
  }
  return null;
}
