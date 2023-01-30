import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/providers/providers.dart';

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
    final firestore = ref.watch(fireStoreProvider);
    final auth = ref.watch(authProvider);
    Stream<DocumentSnapshot<Map<String, dynamic>>> flashcardStream = firestore
        .collection('flashcardSets')
        .doc(auth.auth.currentUser!.uid.toString())
        .collection('sets')
        .doc(widget.title)
        .snapshots();
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
                      .update({
                    'flashcards': FieldValue.arrayUnion([
                      {
                        'definition': 'test asdd def',
                        'isStarred': false,
                        'regenerations': 3,
                        'term': 'test adsd term',
                      }
                    ])
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Add')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
                onPressed: () async {
                  Map<String, dynamic> deleteCard = {};
                  print('is error before?');
                  // deleteCard["flashcards"][0] = FieldValue.arrayRemove([
                  //   {
                  //     'flashcards': [
                  //       {
                  //         'definition': 'test asdd def',
                  //         'isStarred': false,
                  //         'regenerations': 3,
                  //         'term': 'test adsd term',
                  //       }
                  //     ],
                  //   }
                  // ]);
                  // todo: fix thisf
                  print('is error after?');
                  await firestore
                      .collection('flashcardSets')
                      .doc(auth.auth.currentUser!.uid.toString())
                      .collection('sets')
                      .doc(widget.title)
                      .update({
                    'flashcards': FieldValue.arrayRemove([
                      {
                        'definition': 'test asdd def',
                        'isStarred': false,
                        'regenerations': 3,
                        'term': 'test adsd term',
                      }
                    ])
                  });
                },
                label: const Text('Delete')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
                onPressed: () {}, label: const Text('Clear All')),
          )
        ],
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: flashcardStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.data()!['flashcards'].length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(snapshot.data!.data()!['flashcards'][index]['term']),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(snapshot.data!.data()!['flashcards'][index]
                          ['definition']),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(snapshot.data!
                            .data()!['flashcards'][index]['isStarred']
                            .toString()),
                      ),
                    ],
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
