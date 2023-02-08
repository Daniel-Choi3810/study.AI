import 'package:flutter/material.dart';
import 'package:intellistudy/utils/utils.dart';

class SearchField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      // height: height * 0.07,
      width: width * 0.5,
      child: TextField(
        cursorColor: Colors.grey,
        controller: _textFieldController,
        decoration: const InputDecoration(
          filled: true,
          fillColor: AppColors.dominant,
          isDense: true, // Added this
          contentPadding: EdgeInsets.all(25), // Added this
          prefixIcon: Padding(
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
          enabledBorder: OutlineInputBorder(
            // none
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: AppColors.complementary),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          hintText: 'Enter your question...',
          hintStyle: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
            // fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
