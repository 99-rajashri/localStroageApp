import 'package:flutter/material.dart';

class TextFeildInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final IconData? icon;
  final String? Function(String?)? validator;

  const TextFeildInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    this.icon,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPass,
      controller: textEditingController,
      validator: validator, // Apply the validator
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: Colors.black45,
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: InputBorder.none,
        filled: true,
        fillColor: const Color(0xFFedf0f8),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.blue),
          borderRadius: BorderRadius.circular(30),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.red),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.red),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
