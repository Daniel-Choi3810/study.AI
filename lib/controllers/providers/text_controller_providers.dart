import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/controllers/text_controller_notifier.dart';

final answerTextProvider =
    StateNotifierProvider.autoDispose<TextControllerNotifier, String?>(
  (ref) => TextControllerNotifier(ref),
); // This is the provider that is used to access the text controller
final isLoadingProvider = StateProvider.autoDispose((ref) =>
    false); // This is the provider that is used to access the loading state
final responsesProvider = StateProvider.autoDispose((ref) => []);
final searchFieldProvider =
    StateProvider.autoDispose(((ref) => TextEditingController()));
