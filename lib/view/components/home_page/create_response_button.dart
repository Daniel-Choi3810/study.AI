import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/providers.dart';

class CreateResponseButton extends ConsumerStatefulWidget {
  const CreateResponseButton(
      {super.key, required this.searchFieldTextController});

  final TextEditingController searchFieldTextController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateResponseButtonState();
}

class _CreateResponseButtonState extends ConsumerState<CreateResponseButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      minWidth: 225,
      onPressed: createResponse,
      child: const Text(
        'Create',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  void createResponse() async {
    String prompt = widget.searchFieldTextController.text.trim();
    widget.searchFieldTextController.clear();
    // TODO: REFACTOR THIS METHOD TO SEPARATE FILE
    if (prompt.isNotEmpty && prompt.trim().isNotEmpty) {
      ref.read(isValidStateProvider.notifier).update((state) => true);
      // If search field is not empty, get answer text with prompt text
      await ref.read(answerTextProvider.notifier).getText(promptText: prompt);
      await ref.read(localDBProvider.notifier).addToList(
          term: prompt, definition: ref.read(answerTextProvider).toString());
    } else {
      // If search field is empty, get answer text with default prompt text
      ref.read(isValidStateProvider.notifier).update((state) => false);
    }
  }
}
