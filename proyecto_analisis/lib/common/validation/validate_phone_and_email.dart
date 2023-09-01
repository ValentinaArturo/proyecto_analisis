import 'package:flutter/material.dart';

String? validateEmailOrPhone(
    final String value,
    final BuildContext context,
    ) {
  const pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final regex = RegExp(pattern);
  const patternPhone =
      r'^[0-9]+$';
  final regexPhone = RegExp(patternPhone);
  if (!regex.hasMatch(value) && !regexPhone.hasMatch(value)) {
    return "Numero de telefono o correo invalido";
  }
  return null;
}