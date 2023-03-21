import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class SearchCard extends ConsumerStatefulWidget {
  const SearchCard(
      {super.key,
      required this.question,
      required this.answer,
      required this.index});

  final String question;
  final String answer;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchCardState();
}

class _SearchCardState extends ConsumerState<SearchCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35.0, bottom: 16.0, right: 35.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, right: 15),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () async {
                    await ref
                        .read(localSearchDBProvider.notifier)
                        .removeFromList(index: widget.index);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.red,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 50.0,
                right: 50.0,
              ),
              child: AutoSizeText(
                widget.question,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 50.0,
                right: 50.0,
                bottom: 30.0,
                top: 10.0,
              ),
              child: AutoSizeText(
                widget.answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
