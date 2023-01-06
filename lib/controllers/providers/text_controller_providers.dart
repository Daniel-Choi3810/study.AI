import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/controllers/text_controller.dart';

final answerTextProvider =
    StateNotifierProvider<TextController, String>((ref) => TextController(ref));
final isLoadingProvider = StateProvider((ref) => false);
final answerProvider = FutureProvider((ref) {
  final textController = ref.watch(answerTextProvider);
  return textController;
});
