import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/providers.dart';

class CardSide extends ConsumerStatefulWidget {
  const CardSide(
      {super.key,
      required this.title,
      required this.text,
      required this.side,
      required this.height,
      required this.width,
      required this.id,
      required this.onPressed});
  final String text;
  final String side;
  final void Function() onPressed;
  final double height;
  final double width;
  final String title;
  final int id;

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
        .snapshots()
        .map((querySnap) => {
              'data': querySnap.docs
                  .map((doc) => {'id': doc.id, 'data': doc.data()})
                  .toList(),
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
                          // print(
                          //     "id: ${(snapshot.data! as Map)['data'][widget.id]['id']}");
                          await firestore
                              .collection('flashcardSets')
                              .doc(auth.auth.currentUser!.uid.toString())
                              .collection('sets')
                              .doc(widget.title)
                              .collection('cards')
                              .doc((snapshot.data! as Map)['data'][widget.id]
                                      ['id']
                                  .toString())
                              .update({
                            'isStarred': !(snapshot.data! as Map)['data']
                                [widget.id]['data']['isStarred']
                          });
                        },
                        icon: (snapshot.data! as Map)['data'][widget.id]['data']
                                ['isStarred']
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
