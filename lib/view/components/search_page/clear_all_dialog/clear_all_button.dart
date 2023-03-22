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
    return FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: AppColors.red,
        hoverColor: AppColors.darkRed,
        heroTag: null,
        // label: Text(
        //   "Clear All",
        //   style: TextStyle(
        //     color: Colors.grey.shade100,
        //     fontSize: 16,
        //   ),
        // ),
        onPressed: widget.onPressed,
        child: Icon(
          Icons.delete,
          color: Colors.grey.shade100,
        ));
  }
}
