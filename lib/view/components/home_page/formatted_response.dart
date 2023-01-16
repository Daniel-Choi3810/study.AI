import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/providers.dart';

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
  FocusNode termFocusNode = FocusNode();
  FocusNode definitionFocusNode = FocusNode();
  final termSavedProvider = StateProvider<bool>((ref) => true);
  final definitionSavedProvider = StateProvider<bool>((ref) => true);

  @override
  void initState() {
    super.initState();
    termFocusNode.addListener(() {
      if (!termFocusNode.hasFocus) {
        print("in if statement");
        ref.read(termSavedProvider.notifier).state = true;
        ref.read(dbProvider.notifier).editTerm(
            index: widget.id,
            term: ref
                .read(termTextStateProvider.notifier)
                .state
                .toString()
                .trim());
      } else {
        print('in else statement');
        ref.read(dbProvider.notifier).loadPreviousResponse(index: widget.id);
        ref.read(termSavedProvider.notifier).state = false;
      }
    });
    definitionFocusNode.addListener(() {
      if (!definitionFocusNode.hasFocus) {
        ref.read(definitionSavedProvider.notifier).state = true;
        ref.read(dbProvider.notifier).editDefinition(
            index: widget.id,
            definition: ref
                .read(definitionTextStateProvider.notifier)
                .state
                .toString()
                .trim());
      } else {
        ref.read(dbProvider.notifier).loadPreviousResponse(index: widget.id);
        ref.read(definitionSavedProvider.notifier).state = false;
      }
    });
  }

  @override
  void dispose() {
    termFocusNode.dispose();
    definitionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final termSaved = ref.watch(termSavedProvider);
    final definitionSaved = ref.watch(definitionSavedProvider);
    // final count = ref.watch(responsesCountProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 200.0, vertical: 20),
      child: Container(
        height: widget.height * 0.25,
        width: widget.width * 0.9,
        padding: const EdgeInsets.all(20),
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
              children: [
                const Align(
                  alignment: Alignment(0, 0),
                  child: Text(
                    "Term:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                SizedBox(
                  width: widget.width * 0.337,
                ),
                const Text("Definition:",
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
                      focusNode: termFocusNode,
                      onTap: () => ref
                          .read(termTextStateProvider.notifier)
                          .state = "${widget.searchList[widget.id][0]}",
                      onChanged: (term) {
                        ref.read(termTextStateProvider.notifier).state =
                            term.trim();
                        print(ref.read(termTextStateProvider));
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: "${widget.searchList[widget.id][1]}",
                      focusNode: definitionFocusNode,
                      onTap: () => ref
                          .read(definitionTextStateProvider.notifier)
                          .state = "${widget.searchList[widget.id][1]}",
                      onChanged: (definition) {
                        ref.read(definitionTextStateProvider.notifier).state =
                            definition.trim();
                        print(ref.read(definitionTextStateProvider));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () async {
                        await ref
                            .read(dbProvider.notifier)
                            .removeFromList(index: widget.id);
                      },
                      icon: const Icon(Icons.delete)),
                  Text(
                    termSaved && definitionSaved ? '' : "Unsaved changes",
                    style: TextStyle(
                        color: termSaved && definitionSaved
                            ? Colors.white
                            : Colors.red),
                  ),
                  IconButton(
                      onPressed: () async {
                        await ref.read(dbProvider.notifier).regenerateResponse(
                              index: widget.id,
                              term: "${widget.searchList[widget.id][0]}",
                            );
                      },
                      icon: const Icon(Icons.redo_rounded))
                  //  : const Text("No more responses left"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
