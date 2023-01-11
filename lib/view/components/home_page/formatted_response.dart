import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/controllers/providers/text_controller_providers.dart';

class FormattedResponse extends ConsumerStatefulWidget {
  const FormattedResponse({
    super.key,
    required this.height,
    required this.width,
    required this.searchList,
    required this.id,
  });

  final double height;
  final int id;
  final List<List<String>> searchList;
  final double width;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      FormattedResponseState();
}

class FormattedResponseState extends ConsumerState<FormattedResponse> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: widget.height * 0.2,
        width: widget.width * 0.5,
        decoration: const BoxDecoration(color: Colors.black),
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                IconButton(
                    onPressed: () async {
                      await ref
                          .read(responsesProvider.notifier)
                          .removeFromList(index: widget.id);
                      print(ref.read(responsesProvider));
                    },
                    icon: const Icon(Icons.delete))
              ],
            ),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: AutoSizeText(
                  "Term #${widget.id}: ${widget.searchList[widget.id][0]}",
                  maxLines: 6,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: AutoSizeText(
                  " Definition: ${widget.searchList[widget.id][1]}",
                  maxLines: 6,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
