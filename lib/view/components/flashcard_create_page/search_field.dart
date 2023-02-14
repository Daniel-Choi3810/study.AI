import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/utils/utils.dart';

class SearchField extends ConsumerStatefulWidget {
  const SearchField({
    Key? key,
    required TextEditingController textFieldController,
    required this.width,
    required this.height,
  })  : _textFieldController = textFieldController,
        super(key: key);

  final TextEditingController _textFieldController;
  final double width;
  final double height;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  @override
  Widget build(BuildContext context) {
    final textEditingProvider = StateProvider<TextEditingController>((ref) => widget
        ._textFieldController); // TODO: Implement clear button when textfield is not empty
    final textEditingController = ref.watch(textEditingProvider);
    return SizedBox(
      height: widget.height * 0.07,
      width: widget.width * 0.5,
      child: TextField(
        cursorColor: Colors.grey,
        controller: textEditingController,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.dominant,
          isDense: true, // Added this
          contentPadding: const EdgeInsets.all(25), // Added this
          prefixIcon: const Padding(
            padding: EdgeInsets.only(
              right: 10.0,
              left: 10.0,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.search_rounded,
                color: AppColors.complementary,
                size: 30,
              ),
            ),
          ),
          suffixIcon: IconButton(
              icon: const Icon(
                Icons.clear,
              ),
              onPressed: () {
                print(textEditingController.text.isEmpty);
                widget._textFieldController.clear();
              }),
          enabledBorder: const OutlineInputBorder(
            // none
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: AppColors.accentLight),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          hintText: 'Enter your question...',
          hintStyle: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
            // fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
