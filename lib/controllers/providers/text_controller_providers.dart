import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/controllers/text_controller.dart';

final answerTextProvider = StateNotifierProvider<TextController, String>(
  (ref) => TextController(ref),
); // This is the provider that is used to access the text controller
final isLoadingProvider = StateProvider((ref) =>
    false); // This is the provider that is used to access the loading state
final answerProvider = FutureProvider(
  (ref) {
    final textController = ref.watch(answerTextProvider);
    return textController;
  },
);
