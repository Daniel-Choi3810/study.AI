import 'package:flutter/material.dart';

class SearchCancelButton extends StatelessWidget {
  const SearchCancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        });
  }
}
