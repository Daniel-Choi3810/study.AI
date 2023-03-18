import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/providers.dart';

class CardSide extends ConsumerStatefulWidget {
  const CardSide(
      {super.key,
      required this.title,
      required this.isStarred,
      required this.text,
      required this.side,
      required this.height,
      required this.width,
      required this.id,
      required this.snapshot,
      required this.docId});
  final String text;
  final bool isStarred;
  final String side;
  final double height;
  final double width;
  final String title;
  final int id;
  final AsyncSnapshot snapshot;
  final String docId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CardSideState();
}

class _CardSideState extends ConsumerState<CardSide> {
  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(fireStoreProvider);
    final auth = ref.watch(authProvider);

    Stream<Map<String, dynamic>> flashcardStream = firestore
        .collection('flashcardSets')
        .doc(auth.auth.currentUser!.uid.toString())
        .collection('sets')
        .doc(widget.title)
        .collection('cards')
        .orderBy("dateExample")
        .snapshots()
        .map((querySnap) => {
              'data': querySnap.docs
                  .map((doc) =>
                      {'id': doc.id, 'data': doc.data(), doc.id: doc.data()})
                  .toList(),
              'id': querySnap.docs.map((e) => e.id).toList(),
            });
    return StreamBuilder<Object>(
        stream: flashcardStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              height: widget.height,
              width: widget.width,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        widget.text,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: IconButton(
                        onPressed: () async {
                          print("ids: ${(snapshot.data! as Map)['id']}");
                          print(
                              "data: ${(snapshot.data! as Map)['data'][widget.id][widget.docId]["isStarred"]}");
                          // print((snapshot.data! as Map)['data'][widget.id]
                          //     ['data']);
                          // print(
                          //     "id: ${(snapshot.data! as Map)['data'][widget.id]['id']}");
                          await firestore
                              .collection('flashcardSets')
                              .doc(auth.auth.currentUser!.uid.toString())
                              .collection('sets')
                              .doc(widget.title)
                              .collection('cards')
                              .doc(widget.docId)
                              .update({
                            'isStarred': !(snapshot.data! as Map)[
                                    'data'] // TODO: Create one widget at the flash card view page to access isstarred correctly
                                [widget.id][widget.docId]["isStarred"]
                          });
                        },
                        icon: (snapshot.data! as Map)['data'][widget.id]
                                [widget.docId]["isStarred"]
                            ? const Icon(Icons.star)
                            : const Icon(
                                Icons.star_border,
                              ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(45.0),
                      child: Text(
                        widget.side,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return const Text('Error');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
