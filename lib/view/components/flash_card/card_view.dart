import 'package:flutter/material.dart';

class CardSide extends StatefulWidget {
  const CardSide(
      {super.key,
      required this.text,
      required this.side,
      required this.isStarred,
      required this.height,
      required this.width,
      required this.onPressed});
  final String text;
  final String side;
  final bool isStarred;
  final void Function() onPressed;
  final double height;
  final double width;

  @override
  State<CardSide> createState() => _CardSideState();
}

class _CardSideState extends State<CardSide> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.text,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: IconButton(
                onPressed: widget.onPressed,
                icon: widget.isStarred
                    ? const Icon(Icons.star)
                    : const Icon(
                        Icons.star_border,
                      ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(45.0),
              child: Text(
                widget.side,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
