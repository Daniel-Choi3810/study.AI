import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
    required TextEditingController textFieldController,
  })  : _textFieldController = textFieldController,
        super(key: key);

  final TextEditingController _textFieldController;

  @override
  Widget build(BuildContext context) {
    return TextField(
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
    );
  }
}
