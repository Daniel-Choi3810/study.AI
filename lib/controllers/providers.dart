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
final isLoadingProvider = StateProvider.autoDispose((ref) => false);

/// This is the provider that is used to access
/// the search field text controller
final searchFieldProvider = StateProvider.autoDispose(((ref) =>
    TextEditingController())); // This is the provider that is used to access the search field text controller

// Hive Database Providers

/// This is the provider that is used to access
/// the database controller to store the responses
/// in the database and display them in the list view
final dbProvider =
    StateNotifierProvider.autoDispose<ResponsesDataBaseController, List>(
        ((ref) => ResponsesDataBaseController()));
