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
      required this.title});
  final AsyncSnapshot snapshot;
  final String id;
  final int index;
  final String title;

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
    // TODO: implement dispose
    termController.dispose();
    definitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement an edit icon and function that uses text field to edit to db.  Use bool provider to determine if its in edit mode or not
    // TODO: when the bool is false, it saves to firebase
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.snapshot.data![widget.index]['data']['isStarred']
                .toString()),
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
                  .delete()
                  .then(
                    (doc) => print("Document deleted"),
                    onError: (e) => print("Error updating document $e"),
                  );
            },
            icon: const Icon(Icons.delete),
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
