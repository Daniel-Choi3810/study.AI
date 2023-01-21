import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/view/components/flash_card/card_side.dart';
import '../../../providers/providers.dart';

class FlashCard extends ConsumerStatefulWidget {
  const FlashCard(
      {required this.term,
      required this.definition,
      required this.id,
      super.key});
  final String term;
  final String definition;
  final int id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FlashCardState();
}

class _FlashCardState extends ConsumerState<FlashCard> {
  @override
  Widget build(BuildContext context) {
    final isStarredProvider =
        StateProvider<bool>((ref) => ref.watch(localDBProvider)[widget.id][3]);

    final isStarred = ref.watch(isStarredProvider);
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
            print(
                'initial value in db: ${ref.read(localDBProvider)[widget.id][3]}');
            ref.read(localDBProvider.notifier).starCard(index: widget.id);
            ref.read(isStarredProvider.notifier).state =
                ref.read(localDBProvider)[widget.id][3];
            print("On the frontside: ${ref.read(localDBProvider)}");
          },
        ),
        back: CardSide(
          text: widget.definition,
          side: "Definition",
          isStarred: isStarred,
          height: height * 0.8,
          width: width * 0.7,
          onPressed: () {
            ref.read(localDBProvider.notifier).starCard(index: widget.id);
            ref.read(isStarredProvider.notifier).state =
                ref.read(localDBProvider)[widget.id][3];
            print("On the backside: ${ref.read(localDBProvider)}");
          },
        ));
  }
}
