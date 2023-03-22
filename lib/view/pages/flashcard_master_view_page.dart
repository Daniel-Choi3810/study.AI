import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/providers/providers.dart';
import 'package:intellistudy/view/components/flashcard_master_view_page/master_flashcard.dart';
import 'package:intellistudy/view/components/header_banner.dart';

import '../components/page_menu_bar.dart';

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
    super.initState();
    if (widget.title.isEmpty) {
      throw Exception('Title is null');
    }
    print("This is the title: ${widget.title}");
  }

  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(fireStoreProvider);
    final auth = ref.watch(authProvider);
    final masterdocLength = ref.watch(masterdocLengthStateProvider);
    Stream<List<Map<String, dynamic>>> flashcardStream = firestore
        .collection('flashcardSets')
        .doc(auth.auth.currentUser!.uid.toString())
        .collection('sets')
        .doc(widget.title)
        .collection("cards")
        .orderBy("dateExample")
        .snapshots()
        .map((querySnap) => querySnap
            .docs // Mapping Stream of CollectionReference to List<QueryDocumentSnapshot>
            .map((doc) => {
                  'id': doc.id,
                  'data': doc.data(),
                  'count': querySnap.docs.length
                }) // Getting each document ID from the data property of QueryDocumentSnapshot
            .toList());
    // flashcardStream.forEach((flashcardList) {
    //   for (var flashcard in flashcardList) {
    //     print(flashcard['term']);
    //   }
    // });

    flashcardStream.listen((data) async {
      // access count
      ref.read(masterdocLengthStateProvider.notifier).state = data[0]['count'];
      print("This is the length: $masterdocLength");
    });

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
                  // iterate through stream and get lenght
                  // await flashcardStream.forEach((flashcardList) {
                  //   flashcardStreamLength++;
                  // });
                  // print(flashcardStreamLength);
                  // delay this add operation by half a second
                  // await Future.delayed(const Duration(milliseconds: 400));
                  // print(masterdocLength);

                  await firestore
                      .collection('flashcardSets')
                      .doc(auth.auth.currentUser!.uid.toString())
                      .collection('sets')
                      .doc(widget.title)
                      .collection("cards")
                      .doc()
                      .set(
                    {
                      'definition': '',
                      'isStarred': false,
                      'regenerations': 3,
                      'term': '',
                      "dateExample": Timestamp.now(),
                    },
                  );
                  // TODO: Set field for time created for each card to sort in order

                  // flashcardStreamLength = 0;
                  // convert int to alphabet
                  // String alphabet = String.fromCharCode(65 + masterdocLength);
                  // print(alphabet);
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
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return TestFlashCardViewPage(
              //     title: widget.title,
              //   );
              // }));
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
      body: Column(
        children: [
          const PageMenuBar(
            title: "My Sets",
          ),
          const HeaderBanner(),
          Center(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: flashcardStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //print(flashcardStream);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 90.0, right: 90.0),
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
        ],
      ),
    );
  }
}
