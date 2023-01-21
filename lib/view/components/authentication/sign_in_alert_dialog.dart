import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showAlertDialog(BuildContext context, WidgetRef ref) {
  // set up the buttons

  // set up the AlertDialog
  AlertDialog alert = const AlertDialog(
    title: Text("Sign up for an account"),
    content: Text("Create an account or login in order to create flashcards."),
    // actions: [
    //   cancelButton,
    //   continueButton,
    // ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
