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
    // final firestoreStreamProvider =
    //     StreamProvider<DocumentSnapshot<Map<String, dynamic>>>((ref) {
    //   return firestore
    //       .collection('flashcardSets')
    //       .doc(auth.auth.currentUser!.uid.toString())
    //       .collection('sets')
    //       .doc(widget.title)
    //       .snapshots();
    // });
    // final firestoreStream = ref.watch(firestoreStreamProvider);
    // return Scaffold(
    //   body: Center(
    //     child: firestoreStream.when(
    //       data: (snapshot) {
    //         // return ListView.builder(
    //           itemCount: snapshot.data()!['flashcards'].length;
    //           itemBuilder: (context, index) {
    //             return Container(
    //               decoration: const BoxDecoration(
    //                 border: Border(
    //                   bottom: BorderSide(
    //                     color: Colors.black,
    //                     width: 1.0,
    //                   ),
    //                 ),
    //               ),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Text(snapshot.data()!['flashcards'][index]['term']),
    //                   Text(snapshot.data()!['flashcards'][index]['definition']),
    //                 ],
    //               ),
    //             );
    //           };
    //       },
    //       loading: () => const Center(child: CircularProgressIndicator()),
    //       error: (error, stack) => const Text('Error'),
    //     ),
    //   ),
    // );

    return Scaffold(
      body: Center(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: firestore
              .collection('flashcardSets')
              .doc(auth.auth.currentUser!.uid.toString())
              .collection('sets')
              .doc(widget.title)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.data()!['flashcards'].length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data!.data()!['flashcards'][index]['term']),
                      Text(snapshot.data!.data()!['flashcards'][index]
                          ['definition']),
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
