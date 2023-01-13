import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/providers.dart';

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
  final List searchList;
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
        height: widget.height * 0.3,
        width: widget.width * 0.5,
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text("${widget.id + 1}."),
                ),
              ],
            ),
            Row(
              children: const [
                Text(
                  "Term:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(
                  width: 305,
                ),
                Text("Definition:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            Expanded(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: "${widget.searchList[widget.id][0]}",
                      onChanged: (term) {
                        ref
                            .read(dbProvider.notifier)
                            .editTerm(index: widget.id, term: term.trim());
                        print(ref.read(dbProvider));
                      },
                      maxLines: 6,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: "${widget.searchList[widget.id][1]}",
                      onChanged: (definition) {
                        ref.read(dbProvider.notifier).editDefinition(
                            index: widget.id, definition: definition.trim());
                        print(ref.read(dbProvider));
                      },
                      maxLines: 6,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                  onPressed: () async {
                    await ref
                        .read(dbProvider.notifier)
                        .removeFromList(index: widget.id);
                  },
                  icon: const Icon(Icons.delete)),
            ),
          ],
        ),
      ),
    );
  }
}
