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
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.title.isEmpty) {
      throw Exception('Title is null');
    }
    print("This is the title: ${widget.title}");
  }

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
                heroTag: null,
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
                },
                icon: const Icon(Icons.add),
                label: const Text('Add')),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: FloatingActionButton.extended(
          //       heroTag: null,
          //       onPressed: () async {
          //         await firestore
          //             .collection('flashcardSets')
          //             .doc(auth.auth.currentUser!.uid.toString())
          //             .collection('sets')
          //             .doc(widget.title)
          //             .collection('cards')
          //             .get()
          //             .then((snapshot) {
          //           for (DocumentSnapshot ds in snapshot.docs) {
          //             ds.reference.delete();
          //           }
          //         });
          //       },
          //       label: const Text('Clear All')),
          // ),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              Navigator.pushNamed(context, '/flashcardView',
                  arguments: widget.title);
            },
            label: const Text('Study cards'),
          ),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return const HomePage();
              // }));
              Navigator.pop(context);
            },
            label: const Text('My Sets'),
          ),
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
                        itemCount: snapshot.data!.length,
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
