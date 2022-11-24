import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.width,
    this.controller,
    required this.hint,
    this.validator,
    this.isPassword
  }) : super(key: key);

  final double width;
  final TextEditingController? controller;
  final String hint;
  final String? Function(String?)? validator;
  final bool? isPassword;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        controller: controller,
        autocorrect: true,
        autofocus: false,
        validator: validator,
        obscureText: isPassword ?? false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
