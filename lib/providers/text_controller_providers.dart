import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/controllers/text_controller.dart';

final answerTextProvider =
    StateNotifierProvider<TextController, String>((ref) => TextController());
final isLoadingProvider = Provider<bool>((ref) => false);
