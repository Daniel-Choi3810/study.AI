import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/providers/providers.dart';
import 'package:intellistudy/utils/utils.dart';

class SearchButton extends ConsumerStatefulWidget {
  const SearchButton(
      {super.key,
      required this.searchFieldTextController,
      required this.width,
      required this.height});

  final TextEditingController searchFieldTextController;
  final double width;
  final double height;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchButtonState();
}

class _SearchButtonState extends ConsumerState<SearchButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      hoverElevation: 10,
      hoverColor: AppColors.accentDark,
      color: AppColors.accent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      minWidth: widget.width * 0.1,
      height: widget.height * 0.08,
      onPressed: createResponse,
      child: const Text(
        'Search',
        style: TextStyle(
          fontSize: 22,
          //fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
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
