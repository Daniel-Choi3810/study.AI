import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/view/components/home_page/clear_all_dialog/cancel_button.dart';
import 'package:intellistudy/view/components/home_page/clear_all_dialog/clear_button.dart';

void showAlertDialog(BuildContext context, WidgetRef ref) {
  // set up the buttons
  Widget cancelButton = const CancelButton();
  Widget continueButton = const ClearButton();

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Clear Responses"),
    content: const Text(
        "Do you really want to clear all of your responses? This action cannot be undone."),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
