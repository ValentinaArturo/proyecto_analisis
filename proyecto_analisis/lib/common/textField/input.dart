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
  final bool isRequired;

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
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return !isSignUp
        ? TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: (text) {
              if ((text == null || text.isEmpty)&& isRequired) {
                return 'El campo es requerido';
              }

              if (validator != null) {
                return validator!(text!);
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
              if ((text == null || text.isEmpty)&& isRequired) {
                return 'El campo es requerido';
              }

              if (validator != null) {
                return validator!(text!);
              }
              return null;
            },
            inputFormatters: inputFormatters,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
                suffixIcon: suffixIcon,
                fillColor: Colors.deepOrange.withOpacity(0.2),
                filled: true,
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
                label: Text(label,style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          );
  }
}
