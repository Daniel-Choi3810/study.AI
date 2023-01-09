import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/controllers/text_controller_notifier.dart';

final answerTextProvider =
    StateNotifierProvider<TextControllerNotifier, String>(
  (ref) => TextControllerNotifier(ref),
); // This is the provider that is used to access the text controller
final isLoadingProvider = StateProvider((ref) =>
    false); // This is the provider that is used to access the loading state

