import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../providers/providers.dart';
import '../components/flash_card/flash_card.dart';

final myBox = Hive.box('flashcardIndexDataBase');
// Check if title is the same, if it is, then use the same index, if not, reset index to 0

class TestFlashCardViewPage extends ConsumerStatefulWidget {
  const TestFlashCardViewPage({required this.title, super.key});
  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TestFlashCardViewPageState();
}

class _TestFlashCardViewPageState extends ConsumerState<TestFlashCardViewPage> {
  // create function that gets doc length
  //     // ref.read(flashcardIndexProvider.notifier).resetIndex();
  //   }
  // }
  final List<DocumentSnapshot> _documents = [];
  final List<DocumentSnapshot> _shuffledDocuments = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build flashcard view page');
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final auth = ref.watch(authProvider);
    final firestore = ref.watch(fireStoreProvider);
    final isShuffle = ref.watch(isShuffleStateProvider);
    // TODO: provider for the size, to rebuild widget index
    // if (titleBox.get('prevFlashcardViewArgs') != widget.title) {
    //   titleBox.put('prevFlashcardViewArgs', widget.title);
    //   ref.read(flashcardIndexProvider.notifier).resetIndex();
    //   print('reset provider index');
    // }
    Stream<Map<String, dynamic>> flashcardStream = firestore
        .collection('flashcardSets')
        .doc(auth.auth.currentUser!.uid.toString())
        .collection('sets')
        .doc(widget.title)
        .collection('cards')
        .snapshots()
        .map((querySnap) => {
              'list': querySnap.docs
                  .map((doc) => {'id': doc.id, 'data': doc.data()})
                  .toList(),
              'count': querySnap.docs.length,
            });

    flashcardStream.listen((data) async {
      ref.read(docLengthStateProvider.notifier).state = await data['count'];
      // print('size: $size');
      // Use the count value here.
    });

    Stream<Map<String, dynamic>> shuffleStream = firestore
        .collection('flashcardSets')
        .doc(auth.auth.currentUser!.uid.toString())
        .collection('sets')
        .doc(widget.title)
        .collection('cards')
        .snapshots()
        .map((querySnap) => {
              'list': querySnap.docs
                  .map((doc) => {'id': doc.id, 'data': doc.data()})
                  .toList()
                ..shuffle(),
              'count': querySnap.docs.length,
            });

    // final db = ref.watch(localFlashcardDBProvider);

    final currentIndex = ref.watch(flashcardIndexProvider);
    // final currentIndex = myBox.get('index');
    // print("size after listen: $size");

    return StreamBuilder(
        stream: flashcardStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // var shuffledDoc = snapshot.data!['list']..shuffle();
            // List<dynamic> shuffledDoc = snapshot.data!['list'];
            final size = snapshot.data!['count'];
            // final shuffleStateProvider =
            //     StateProvider((ref) => snapshot.data!['list'] as List<dynamic>);
            // final shuffleStateNotifierProvider =
            //     StateNotifierProvider<ShuffleStateNotifier, List<dynamic>>(
            //         (ref) => ShuffleStateNotifier(
            //             ref, ref.watch(shuffleStateProvider)));
            // final shuffleState = ref.watch(shuffleStateNotifierProvider);
            return Scaffold(
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(15.0),
                child: FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
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
                            ? Column(
                                // TODO: Make this a separate widget
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Results',
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.grey.shade400),
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
                                              Text(
                                                  '$currentIndex / $size studied')
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Next Steps',
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.grey.shade400),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              ref
                                                  .read(flashcardIndexProvider
                                                      .notifier)
                                                  .resetIndex();
                                            },
                                            icon: const Icon(
                                              Icons.restart_alt_rounded,
                                              size: 30,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).popUntil(
                                                  (route) => route.isFirst);
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
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.8,
                                    child: ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: width * 0.9),
                                      child: IndexedStack(
                                        index: currentIndex,
                                        children: snapshot.data!['list']
                                            .map<Widget>(
                                              (doc) => FlashCard(
                                                title: widget.title,
                                                id: currentIndex,
                                                term: snapshot.data!['list']
                                                        [currentIndex]['data']
                                                    ['term'],
                                                definition:
                                                    snapshot.data!['list']
                                                            [currentIndex]
                                                        ['data']['definition'],
                                              ),
                                            )
                                            .toList(),
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
                                      // print(
                                      //     "Current index after pressing prev: $currentIndex");
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
                                        ref
                                            .read(
                                                flashcardIndexProvider.notifier)
                                            .resetIndex();
                                      },
                                      label: const Text('Restart cards'),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                      onPressed: () async {
                                        ref
                                                .read(isShuffleStateProvider
                                                    .notifier)
                                                .state =
                                            !ref.read(isShuffleStateProvider);

                                        // flashcardStream = flashcardStream
                                        //     .map((flashcardData) {
                                        //   List<Map<String, dynamic>>
                                        //       shuffledList =
                                        //       List<Map<String, dynamic>>.from(
                                        //           flashcardData['list'])
                                        //         ..shuffle();
                                        //   print(shuffledList.toString());
                                        //   print('hello world');
                                        //   return {
                                        //     'list': shuffledList,
                                        //     'count': shuffledList.length,
                                        //   };
                                        // });
                                        // flashcardStream.listen((flashcardData) {
                                        //   print('Flashcard set:');
                                        //   print(
                                        //       '  Count: ${flashcardData['count']}');
                                        //   print('  List:');
                                        //   flashcardData['list']
                                        //       .forEach((flashcardItem) {
                                        //     print(
                                        //         '    ID: ${flashcardItem['id']}');
                                        //     print(
                                        //         '    Data: ${flashcardItem['data']}');
                                        //   });
                                        // });
                                      },
                                      icon: const Icon(Icons.shuffle),
                                      label: const Text('Shuffle')),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (currentIndex + 1 < size) {
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
