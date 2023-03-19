import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        });
  }
}
