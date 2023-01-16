import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/controllers/responses_database_controller.dart';
import 'package:intellistudy/controllers/text_controller_notifier.dart';

// HomePage Providers

/// This is the provider that is used to access
/// the text controller notifier to generate the answer
final answerTextProvider =
    StateNotifierProvider<TextControllerNotifier, String?>(
     (ref) => TextControllerNotifier(ref),
);

/// This is the provider that is used to access
/// the circular progress indicator when the generated
/// response is loading
final isLoadingStateProvider = StateProvider.autoDispose((ref) => false);

/// This is the provider that is used to access
/// the valid prompt message when the user does not
/// enter a valid prompt
final isValidStateProvider = StateProvider.autoDispose((ref) => true);

/// This is the provider that is used to access
/// the search field text controller
final searchFieldStateProvider =
    StateProvider.autoDispose(((ref) => TextEditingController()));

// final responsesCountProvider = StateProvider.autoDispose((ref) => 3);

/// This is the provider that is used to access
/// the term text during editing
final termTextStateProvider = StateProvider<String>((ref) => '');

/// This is the provider that is used to access
/// the definition text during editing
final definitionTextStateProvider = StateProvider<String>((ref) => '');


// Hive Database Providers

/// This is the provider that is used to access
/// the database controller to store the responses
/// in the database and display them in the list view
final dbProvider = StateNotifierProvider<ResponsesDataBaseController, List>(
    ((ref) => ResponsesDataBaseController(ref)));
