import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton(
      {super.key, required this.onPressed, required this.statusText});
  final void Function()? onPressed;
  final String statusText;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      textColor: Colors.blue.shade700,
      textTheme: ButtonTextTheme.primary,
      minWidth: 100,
      padding: const EdgeInsets.all(18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(color: Colors.blue.shade700),
      ),
      child: Text(
        statusText,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
