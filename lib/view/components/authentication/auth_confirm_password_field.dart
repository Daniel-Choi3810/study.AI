import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthConfirmPasswordField extends ConsumerWidget {
  const AuthConfirmPasswordField(
      {required this.validator, super.key, required this.textController});
  final String? Function(String?)? validator;
  final TextEditingController textController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(25)),
      child: TextFormField(
        controller: textController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Confirm password',
          hintStyle: const TextStyle(color: Colors.white),
          icon: Icon(Icons.lock, color: Colors.blue.shade700, size: 24),
          alignLabelWithHint: true,
          border: InputBorder.none,
        ),
        validator: validator,
      ),
    );
  }
}
