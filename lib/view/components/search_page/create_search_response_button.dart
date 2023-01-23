import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/providers/providers.dart';

class SearchButton extends ConsumerStatefulWidget {
  const SearchButton({super.key, required this.searchFieldTextController});

  final TextEditingController searchFieldTextController;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchButtonState();
}

class _SearchButtonState extends ConsumerState<SearchButton> {
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
        'Search',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  void createResponse() async {
    String prompt = widget.searchFieldTextController.text.trim();
    widget.searchFieldTextController.clear();
    // TODO: REFACTOR THIS METHOD TO SEPARATE FILE
    if (prompt.isNotEmpty && prompt.trim().isNotEmpty) {
      ref.read(searchIsValidStateProvider.notifier).update((state) => true);
      // If search field is not empty, get answer text with prompt text
      await ref
          .read(searchAnswerTextProvider.notifier)
          .getText(promptText: prompt);
      await ref.read(localSearchDBProvider.notifier).addToList(
          term: prompt,
          definition: ref.read(searchAnswerTextProvider).toString());
    } else {
      // If search field is empty, get answer text with default prompt text
      ref.read(searchIsValidStateProvider.notifier).update((state) => false);
    }
  }
}
