import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:intellistudy/view/components/flash_card/card_side.dart';

class FlashCard extends StatefulWidget {
  const FlashCard({super.key, required this.term, required this.definition});

  final String term;
  final String definition;

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  bool isStarred = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FlipCard(
        speed: 400,
        direction: FlipDirection.VERTICAL,
        front: CardSide(
          text: widget.term,
          side: "Term",
          isStarred: isStarred,
          height: height * 0.8,
          width: width * 0.7,
          onPressed: () {
            setStar();
          },
        ),
        back: CardSide(
          text: widget.definition,
          side: "Definition",
          isStarred: isStarred,
          height: height * 0.8,
          width: width * 0.7,
          onPressed: () {
            setStar();
          },
        ));
  }

  void setStar() {
    return setState(() {
      isStarred = !isStarred;
    });
  }
}
