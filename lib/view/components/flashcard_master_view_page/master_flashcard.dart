import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/utils/utils.dart';

import '../../../providers/providers.dart';

class MasterFlashcard extends ConsumerStatefulWidget {
  const MasterFlashcard(
      {super.key,
      required this.snapshot,
      required this.id,
      required this.index,
      required this.title,
      required this.itemCount});
  final AsyncSnapshot snapshot;
  final String id;
  final int index;
  final String title;
  final int itemCount;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MasterFlashcardState();
}

class _MasterFlashcardState extends ConsumerState<MasterFlashcard> {
  final isEditStateProvider = StateProvider.autoDispose((ref) => false);
  final TextEditingController termController = TextEditingController();
  final TextEditingController definitionController = TextEditingController();

  @override
  void dispose() {
    termController.dispose();
    definitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final firestore = ref.watch(fireStoreProvider);
    final isEdit = ref.watch(isEditStateProvider);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.index.toString()),
          Text(widget.id),
          const SizedBox(
            width: 20,
          ),
          isEdit
              ? Expanded(
                  child: TextField(
                    controller: termController
                      ..text =
                          widget.snapshot.data![widget.index]['data']['term'],
                  ),
                )
              : Text(widget.snapshot.data![widget.index]['data']['term']),
          const SizedBox(
            width: 20,
          ),
          isEdit
              ? Expanded(
                  child: TextField(
                    controller: definitionController
                      ..text = widget.snapshot.data![widget.index]['data']
                          ['definition'],
                  ),
                )
              : Text(widget.snapshot.data![widget.index]['data']['definition']),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () async {
              if (widget.itemCount > 2) {
                await firestore
                    .collection('flashcardSets')
                    .doc(auth.auth.currentUser!.uid.toString())
                    .collection('sets')
                    .doc(widget.title)
                    .collection('cards')
                    .doc(widget.id)
                    .delete()
                    .then(
                      (doc) => print("Document deleted"),
                      onError: (e) => print("Error updating document $e"),
                    );
              }
            },
            icon: widget.itemCount > 2
                ? const Icon(Icons.delete)
                : const Icon(
                    Icons.delete,
                    color: Colors.black54,
                  ),
          ),
          IconButton(
            onPressed: () async {
              ref.read(isEditStateProvider.notifier).state =
                  !ref.read(isEditStateProvider.notifier).state;
              if (ref.read(isEditStateProvider.notifier).state == false) {
                await firestore
                    .collection('flashcardSets')
                    .doc(auth.auth.currentUser!.uid.toString())
                    .collection('sets')
                    .doc(widget.title)
                    .collection('cards')
                    .doc(widget.id)
                    .update({
                  'term': termController.text.trim(),
                  'definition': definitionController.text.trim(),
                }).then(
                  (doc) => print("Document updated"),
                  onError: (e) => print("Error updating document $e"),
                );
              }
            },
            icon: Icon(Icons.edit,
                color: isEdit ? AppColors.accentLight : Colors.black),
          ),
          IconButton(
            onPressed: () async {
              await firestore
                  .collection('flashcardSets')
                  .doc(auth.auth.currentUser!.uid.toString())
                  .collection('sets')
                  .doc(widget.title)
                  .collection('cards')
                  .doc(widget.id)
                  .update({
                'isStarred': !widget.snapshot.data![widget.index]['data']
                    ['isStarred']
              }).then(
                (doc) => print("Document updated"),
                onError: (e) => print("Error updating document $e"),
              );
            },
            icon: Icon(
              Icons.star,
              color: widget.snapshot.data![widget.index]['data']['isStarred']
                  ? Colors.yellowAccent
                  : Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
