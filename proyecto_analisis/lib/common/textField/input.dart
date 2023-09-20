import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color? color;
  final Function(String)? validator;
  final bool obscureText;
  final bool isSignUp;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;

  const CustomInput({
    super.key,
    required this.controller,
    required this.label,
    this.color,
    this.validator,
    this.obscureText = false,
    this.isSignUp = false,
    this.inputFormatters,
    this.suffixIcon,
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
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
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
                suffixIcon: suffixIcon,
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
