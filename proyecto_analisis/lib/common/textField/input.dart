import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color? color;
  final Function(String)? validator;
  final bool obscureText;
  final bool isSignUp;

  const CustomInput({
    super.key,
    required this.controller,
    required this.label,
    this.color,
    this.validator,
    this.obscureText = false,
    this.isSignUp = false,
  });

  @override
  Widget build(BuildContext context) {
    return !isSignUp
        ? TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'El campo es requerido';
              }

              if (validator != null) {
                return validator!(text);
              }
              return null;
            },
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                filled: true,
                label: Text(label),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          )
        : TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'El campo es requerido';
              }

              if (validator != null) {
                return validator!(text);
              }
              return null;
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                hintText: label,
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          );
  }
}
