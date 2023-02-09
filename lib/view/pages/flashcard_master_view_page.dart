import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/providers/providers.dart';
import 'package:intellistudy/view/components/flashcard_master_view_page/master_flashcard.dart';

class FlashcardMasterViewPage extends ConsumerStatefulWidget {
  const FlashcardMasterViewPage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FlashcardMasterViewPageState();
}

class _FlashcardMasterViewPageState
    extends ConsumerState<FlashcardMasterViewPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: Master view page of cards created, like quizlet
    final firestore = ref.watch(fireStoreProvider);
    final auth = ref.watch(authProvider);
    Stream<List<Map<String, dynamic>>> flashcardStream = firestore
        .collection('flashcardSets')
        .doc(auth.auth.currentUser!.uid.toString())
        .collection('sets')
        .doc(widget.title)
        .collection('cards')
        .snapshots()
        .map((querySnap) => querySnap
            .docs // Mapping Stream of CollectionReference to List<QueryDocumentSnapshot>
            .map((doc) => {
                  'id': doc.id,
                  'data': doc.data()
                }) // Getting each document ID from the data property of QueryDocumentSnapshot
            .toList());
    // flashcardStream.forEach((flashcardList) {
    //   for (var flashcard in flashcardList) {
    //     print(flashcard['term']);
    //   }
    // });
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
                onPressed: () async {
                  await firestore
                      .collection('flashcardSets')
                      .doc(auth.auth.currentUser!.uid.toString())
                      .collection('sets')
                      .doc(widget.title)
                      .collection('cards')
                      .doc()
                      .set(
                    {
                      'definition': '',
                      'isStarred': false,
                      'regenerations': 3,
                      'term': '',
                    },
                  );
                  // .update({
                  //   'flashcards': FieldValue.arrayUnion([
                  //     {
                  //       'definition': 'test asdd def',
                  //       'isStarred': false,
                  //       'regenerations': 3,
                  //       'term': 'test adsd term',
                  //     }
                  //   ])
                  // });
                },
                icon: const Icon(Icons.add),
                label: const Text('Add')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
                onPressed: () async {
                  await firestore
                      .collection('flashcardSets')
                      .doc(auth.auth.currentUser!.uid.toString())
                      .collection('sets')
                      .doc(widget.title)
                      .collection('cards')
                      .get()
                      .then((snapshot) {
                    for (DocumentSnapshot ds in snapshot.docs) {
                      ds.reference.delete();
                    }
                  });
                },
                label: const Text('Clear All')),
          )
        ],
      ),
      body: Center(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: flashcardStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //print(flashcardStream);
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MasterFlashcard(
                        snapshot: snapshot,
                        title: widget.title,
                        id: snapshot.data![index]['id'],
                        index: index),
                  );
                },
              );
            }
            if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
