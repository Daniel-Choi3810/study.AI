import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../providers/providers.dart';

final myBox = Hive.box('flashcardIndexDataBase');
// Check if title is the same, if it is, then use the same index, if not, reset index to 0

class FlashCardViewPage extends ConsumerStatefulWidget {
  const FlashCardViewPage({required this.title, super.key});
  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FlashCardViewPageState();
}

class _FlashCardViewPageState extends ConsumerState<FlashCardViewPage> {
  List<Map<String, Object>> _documents = [];
  // List<Map<String, Object>> _shuffledDocuments = [];
  // create function that gets doc length
  PageController flashCardController =
      PageController(initialPage: myBox.get('index') ?? 0, keepPage: true);

  @override
  void initState() {
    super.initState();
    print('widget rebuild');
    _subscribeToData();
    ref.read(isShuffleStateNotifierProvider.notifier).loadData();
    print(ref.read(isShuffleStateNotifierProvider));
  }

  void _subscribeToData() {
    FirebaseFirestore.instance
        .collection('flashcardSets')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('sets')
        .doc(widget.title)
        .collection("cards")
        .orderBy("dateExample")
        .snapshots()
        .listen((querySnapshot) {
      _documents = querySnapshot.docs
          .map((doc) => {'id': doc.id, 'data': doc.data()})
          .toList();
      // _shuffledDocuments = querySnapshot.docs
      //     .map((doc) => {'id': doc.id, 'data': doc.data()})
      //     .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('widget rebuild in the build context');
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final auth = ref.watch(authProvider);
    final firestore = ref.watch(fireStoreProvider);
    final isShuffle = ref.watch(isShuffleStateNotifierProvider);

    Stream<Map<String, dynamic>> flashcardStream = firestore
        .collection('flashcardSets')
        .doc(auth.auth.currentUser!.uid.toString())
        .collection('sets')
        .doc(widget.title)
        .collection("cards")
        // .orderBy(
        //   'dateExample',
        // )
        .snapshots()
        .map((querySnap) => {
              'list': querySnap.docs
                  .map((doc) => {'id': doc.id, 'data': doc.data()})
                  .toList(),
              'count': querySnap.docs.length,
            });

    flashcardStream.listen((data) async {
      ref.read(docLengthStateProvider.notifier).state = await data['count'];
    });

    final currentIndex = ref.watch(flashcardIndexProvider);
    return StreamBuilder(
        stream: flashcardStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final size = _documents.length;
            return Scaffold(
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(15.0),
                child: FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    // ref
                    //     .read(isShuffleStateNotifierProvider.notifier)
                    //     .clearData();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  label: const Text('Back to Home page'),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: currentIndex == size
                          ? Text('$currentIndex / $size')
                          : Text('${(currentIndex as int) + 1} / $size'),
                      // : const Text('yo mamas so fat, she needs two numbers'),
                    ),
                    LinearProgressIndicator(
                      minHeight: 2,
                      value: (currentIndex as int) / size,
                      backgroundColor: Colors.grey,
                    ),
                    Column(
                      children: [
                        // SizedBox(
                        //   height: height * 0.1,
                        // ),
                        currentIndex == size
                            ? CompleteScreen(
                                height: height,
                                currentIndex: currentIndex,
                                size: size,
                                ref: ref)
                            : Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.8,
                                    child: ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: width * 0.9),
                                      child: PageView.builder(
                                        controller: flashCardController,
                                        itemBuilder: (_, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 150.0,
                                                vertical: 50.0),
                                            child: FlipCard(
                                              speed: 300,
                                              direction: FlipDirection.VERTICAL,
                                              front: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          (_documents[index]
                                                                  ['data']
                                                              as Map)['term'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 30),
                                                        ),
                                                        // child: Text(
                                                        //   isShuffle
                                                        //       ? (_shuffledDocuments[
                                                        //                       index]
                                                        //                   [
                                                        //                   'data']
                                                        //               as Map)[
                                                        //           'term']
                                                        //       : (_documents[
                                                        //                   index]
                                                        //               ['data']
                                                        //           as Map)['term'],
                                                        //   style:
                                                        //       const TextStyle(
                                                        //           fontSize: 30),
                                                        // ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(30.0),
                                                        child: IconButton(
                                                          onPressed: () async {
                                                            await firestore
                                                                .collection(
                                                                    'flashcardSets')
                                                                .doc(auth
                                                                    .auth
                                                                    .currentUser!
                                                                    .uid
                                                                    .toString())
                                                                .collection(
                                                                    'sets')
                                                                .doc(widget
                                                                    .title)
                                                                .collection(
                                                                    'cards')
                                                                .doc(
                                                                  // isShuffle
                                                                  //     ? (_shuffledDocuments[index])[
                                                                  //             'id']
                                                                  //         .toString() :
                                                                  (_documents[index])[
                                                                          'id']
                                                                      .toString(),
                                                                )
                                                                .update({
                                                              'isStarred':
                                                                  // isShuffle
                                                                  //     ? !(_shuffledDocuments[index]
                                                                  //                 [
                                                                  //                 'data']
                                                                  //             as Map)[
                                                                  //         'isStarred']
                                                                  //     :
                                                                  !(_documents[index]
                                                                              [
                                                                              'data']
                                                                          as Map)[
                                                                      'isStarred']
                                                            });
                                                          },
                                                          icon:
                                                              // isShuffle
                                                              //     ? (_shuffledDocuments[index]
                                                              //                     [
                                                              //                     'data']
                                                              //                 as Map)[
                                                              //             'isStarred']
                                                              //         ? const Icon(
                                                              //             Icons
                                                              //                 .star,
                                                              //             color: Colors
                                                              //                 .yellow,
                                                              //           )
                                                              //         : const Icon(
                                                              //             Icons
                                                              //                 .star_border,
                                                              //             color: Colors
                                                              //                 .black,
                                                              //           )
                                                              //     :
                                                              (_documents[index]
                                                                              [
                                                                              'data']
                                                                          as Map)[
                                                                      'isStarred']
                                                                  ? const Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                          .yellow,
                                                                    )
                                                                  : const Icon(
                                                                      Icons
                                                                          .star_border,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            45.0),
                                                        child: Text("Term"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              back: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          // isShuffle
                                                          //     ? (_shuffledDocuments[index]
                                                          //                 [
                                                          //                 'data']
                                                          //             as Map)[
                                                          //         'definition']
                                                          //     :
                                                          (_documents[index]
                                                                      ['data']
                                                                  as Map)[
                                                              'definition'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 30),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(30.0),
                                                        child: IconButton(
                                                          onPressed: () async {
                                                            await firestore
                                                                .collection(
                                                                    'flashcardSets')
                                                                .doc(auth
                                                                    .auth
                                                                    .currentUser!
                                                                    .uid
                                                                    .toString())
                                                                .collection(
                                                                    'sets')
                                                                .doc(widget
                                                                    .title)
                                                                .collection(
                                                                    'cards')
                                                                .doc(
                                                                  // isShuffle
                                                                  //     ? (_shuffledDocuments[index])[
                                                                  //             'id']
                                                                  //         .toString()
                                                                  //     :
                                                                  (_documents[index])[
                                                                          'id']
                                                                      .toString(),
                                                                )
                                                                .update({
                                                              'isStarred':
                                                                  //  isShuffle
                                                                  //     ? !(_shuffledDocuments[index]
                                                                  //                 [
                                                                  //                 'data']
                                                                  //             as Map)[
                                                                  //         'isStarred']
                                                                  //     :
                                                                  !(_documents[index]
                                                                              [
                                                                              'data']
                                                                          as Map)[
                                                                      'isStarred']
                                                            });
                                                          },
                                                          icon:
                                                              //  isShuffle
                                                              //     ? (_shuffledDocuments[index]
                                                              //                     [
                                                              //                     'data']
                                                              //                 as Map)[
                                                              //             'isStarred']
                                                              //         ? const Icon(
                                                              //             Icons
                                                              //                 .star,
                                                              //             color: Colors
                                                              //                 .yellow,
                                                              //           )
                                                              //         : const Icon(
                                                              //             Icons
                                                              //                 .star_border,
                                                              //             color: Colors
                                                              //                 .black,
                                                              //           )
                                                              //     :
                                                              (_documents[index]
                                                                              [
                                                                              'data']
                                                                          as Map)[
                                                                      'isStarred']
                                                                  ? const Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                          .yellow,
                                                                    )
                                                                  : const Icon(
                                                                      Icons
                                                                          .star_border,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            45.0),
                                                        child: Text("Term"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: size,
                                        onPageChanged: (index) {
                                          ref
                                              .read(flashcardIndexProvider
                                                  .notifier)
                                              .setIndex(index: index);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                    currentIndex == size
                        ? const SizedBox()
                        : Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 40.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (currentIndex - 1 >= 0) {
                                        ref
                                            .read(
                                                flashcardIndexProvider.notifier)
                                            .decrementIndex();
                                      }
                                      print(
                                          "Current index after pressing prev: $currentIndex");
                                      flashCardController.animateToPage(
                                          ref
                                              .read(flashcardIndexProvider
                                                  .notifier)
                                              .getIndex(),
                                          duration:
                                              const Duration(milliseconds: 250),
                                          curve: Curves.linear);
                                    },
                                    icon: const Icon(Icons.chevron_left),
                                    label: const Text('Prev'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.restart_alt),
                                      onPressed: () {
                                        ref
                                            .read(
                                                flashcardIndexProvider.notifier)
                                            .resetIndex();
                                        flashCardController.animateToPage(
                                            ref
                                                .read(flashcardIndexProvider
                                                    .notifier)
                                                .getIndex(),
                                            duration: const Duration(
                                                milliseconds: 250),
                                            curve: Curves.linear);
                                      },
                                      label: const Text('Restart cards'),
                                    ),
                                  ),
                                  // ElevatedButton.icon(
                                  //     onPressed: () async {
                                  //       _shuffledDocuments = _shuffledDocuments
                                  //         ..shuffle();
                                  //       print(_shuffledDocuments);
                                  //       ref
                                  //           .read(isShuffleStateNotifierProvider
                                  //               .notifier)
                                  //           .toggleIsShuffled();
                                  //       print(isShuffle);
                                  //     },
                                  //     icon: Icon(
                                  //       Icons.shuffle,
                                  //       color: isShuffle
                                  //           ? Colors.black
                                  //           : Colors.white,
                                  //     ),
                                  //     label: const Text('Shuffle')),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (currentIndex + 1 < size) {
                                        ref
                                            .read(
                                                flashcardIndexProvider.notifier)
                                            .incrementIndex();
                                        flashCardController.animateToPage(
                                            ref
                                                .read(flashcardIndexProvider
                                                    .notifier)
                                                .getIndex(),
                                            duration: const Duration(
                                                milliseconds: 250),
                                            curve: Curves.linear);
                                      } else {
                                        ref
                                            .read(
                                                flashcardIndexProvider.notifier)
                                            .incrementIndex();
                                      }
                                    },
                                    icon: const Icon(Icons.chevron_right),
                                    label: const Text('Next'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
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

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({
    super.key,
    required this.height,
    required this.currentIndex,
    required this.size,
    required this.ref,
  });

  final double height;
  final Object? currentIndex;
  final int size;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height * 0.1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Congratulations, you have finished the deck!',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.celebration,
              size: 100,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  'Results',
                  style: TextStyle(fontSize: 24, color: Colors.grey.shade400),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.thumb_up_alt_rounded,
                        color: Colors.greenAccent,
                      ),
                    ),
                    Text('$currentIndex / $size studied')
                  ],
                )
              ],
            ),
            Column(
              children: [
                Text(
                  'Next Steps',
                  style: TextStyle(fontSize: 24, color: Colors.grey.shade400),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(flashcardIndexProvider.notifier).resetIndex();
                  },
                  icon: const Icon(
                    Icons.restart_alt_rounded,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(
                    Icons.home,
                    size: 30,
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
