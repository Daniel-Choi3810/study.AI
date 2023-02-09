import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final firestore = ref.watch(fireStoreProvider);
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
          Text(widget.id),
          const SizedBox(
            width: 20,
          ),
          Text(widget.snapshot.data![widget.index]['data']['term']),
          const SizedBox(
            width: 20,
          ),
          Text(widget.snapshot.data![widget.index]['data']['definition']),
          const SizedBox(
            width: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.snapshot.data![widget.index]['data']['isStarred']
                .toString()),
          ),
          IconButton(
            onPressed: () {
              firestore
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
        ],
      ),
    );
  }
}
