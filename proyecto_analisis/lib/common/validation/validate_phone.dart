import 'package:flutter/material.dart';

String? validatePhone(
  final String value,
  final String dial,
  final BuildContext context,
) {
  if (value.isEmpty) {
    return "Numero de telefono invalido";
  }
  String pattern;
  switch (dial) {
    case '+1':
      pattern = r'^[0-9]{7,10}$';
      break;
    case '+502':
      pattern = r'^[0-9]{8}$';
      break;
    default:
      pattern = r'^[0-9]{7,10}$';
      break;
  }

  final regex = RegExp(pattern);
  return !regex.hasMatch(value)
      ? "Numero de telefono invalido"
      : null;
}

String? validateCompletePhone(
  final String value,
  final BuildContext context,
) {
  if (value.isEmpty) {
    return "Numero de telefono invalido";
  }

  final regexUSPhone = RegExp(r'^\+1[0-9]{7,10}$');
  final regexCentralAmericaPhone = RegExp(r'^\+50[1-7][0-9]{8}$');
  final regexGeneralPhone = RegExp(r'^[0-9]{7,10}$');

  if (regexUSPhone.hasMatch(value)) {
    return null;
  } else if (regexCentralAmericaPhone.hasMatch(value)) {
    return null;
  } else if (regexGeneralPhone.hasMatch(value)) {
    return null;
  }

  return "Numero de telefono invalido";
}
