import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

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
      front: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        height: height * 0.8,
        width: width * 0.7,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.term,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isStarred = !isStarred;
                    });
                  },
                  icon: isStarred
                      ? const Icon(Icons.star)
                      : const Icon(
                          Icons.star_border,
                        ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(45.0),
                child: Text(
                  "Term",
                ),
              ),
            ),
          ],
        ),
      ),
      back: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        height: height * 0.8,
        width: width * 0.7,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.definition,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isStarred = !isStarred;
                    });
                  },
                  icon: isStarred
                      ? const Icon(Icons.star)
                      : const Icon(
                          Icons.star_border,
                        ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(45.0),
                child: Text(
                  "Definition",
                ),
              ),
            ),
          ],
        ),
      ),
      // height: height * 0.8,
      // width: width * 0.7,
    );
  }
}
