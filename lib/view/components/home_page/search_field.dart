import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
    required TextEditingController textFieldController,
    required this.width,
  })  : _textFieldController = textFieldController,
        super(key: key);

  final TextEditingController _textFieldController;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.7,
      child: TextField(
        controller: _textFieldController,
        decoration: const InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: 10.0,
            ),
            child: Icon(
              Icons.search_rounded,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          hintText: 'Enter your question...',
          hintStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
