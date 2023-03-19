import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/view/components/search_page/clear_all_dialog/search_clear_all_dialog/search_cancel_button.dart';
import 'package:intellistudy/view/components/search_page/clear_all_dialog/search_clear_all_dialog/search_clear_button.dart';

void showSearchAlertDialog(BuildContext context, WidgetRef ref) {
  // set up the buttons
  Widget cancelButton = const SearchCancelButton();
  Widget continueButton = const SearchClearButton();

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Clear Search Responses"),
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
