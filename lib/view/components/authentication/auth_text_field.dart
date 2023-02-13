import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField(
      {super.key,
      required this.textController,
      required this.hintText,
      required this.icon,
      required this.keyboard,
      required this.validator,
      required this.obscureText});
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  final TextInputType keyboard;
  final String? Function(String?)? validator;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: TextFormField(
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textController,
        autocorrect: true,
        enableSuggestions: true,
        keyboardType: keyboard,
        onSaved: (value) {},
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black),
          icon: Icon(icon, color: Colors.blue.shade700, size: 24),
          alignLabelWithHint: true,
          border: InputBorder.none,
        ),
        validator: validator,
        obscureText: obscureText,
      ),
    );
  }
}
