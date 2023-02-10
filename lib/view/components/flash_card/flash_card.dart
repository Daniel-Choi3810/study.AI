import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/view/components/flash_card/card_side.dart';

class FlashCard extends ConsumerStatefulWidget {
  const FlashCard(
      {required this.term,
      required this.definition,
      required this.id,
      required this.title,
      super.key});
  final String term;
  final String definition;
  final int id;
  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FlashCardState();
}

class _FlashCardState extends ConsumerState<FlashCard> {
  @override
  Widget build(BuildContext context) {
    // final isStarredProvider = StateProvider<bool>(
    //     (ref) => ref.watch(localFlashcardDBProvider)[widget.id][3]);

    // final isStarred = ref.watch(isStarredProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return FlipCard(
        speed: 400,
        direction: FlipDirection.VERTICAL,
        front: CardSide(
          title: widget.title,
          text: widget.term,
          side: "Term",
          height: height * 0.8,
          width: width * 0.7,
          id: widget.id,
          onPressed: () {
            // ref.read(isStarredProvider.notifier).state =
            //     ref.read(localFlashcardDBProvider)[widget.id][3];
          },
        ),
        back: CardSide(
          title: widget.title,
          text: widget.definition,
          side: "Definition",
          height: height * 0.8,
          width: width * 0.7,
          id: widget.id,
          onPressed: () {
            // ref.read(isStarredProvider.notifier).state =
            //     ref.read(localFlashcardDBProvider)[widget.id][3];
          },
        ));
  }
}
