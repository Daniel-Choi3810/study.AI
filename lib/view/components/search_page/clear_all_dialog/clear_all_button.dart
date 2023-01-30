import 'package:flutter/material.dart';

import '../../../../utils/utils.dart';

class ClearAllButton extends StatefulWidget {
  const ClearAllButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<ClearAllButton> createState() => _ClearAllButtonState();
}

class _ClearAllButtonState extends State<ClearAllButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        // TODO: Refactor this button to a custom widget
        icon: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
        backgroundColor: AppColors.purple,
        heroTag: null,
        label: const Text("Clear All",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        onPressed: widget.onPressed);
  }
}
