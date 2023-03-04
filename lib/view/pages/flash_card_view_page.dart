import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../providers/providers.dart';
import '../components/flash_card/flash_card.dart';

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
  List<Map<String, Object>> _shuffledDocuments = [];
  // create function that gets doc length
  PageController flashCardController =
      PageController(initialPage: myBox.get('index') ?? 0, keepPage: true);

  @override
  void initState() {
    super.initState();
    print('widget rebuild');
    _subscribeToData();
  }

  void _subscribeToData() {
    FirebaseFirestore.instance
        .collection('flashcardSets')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('sets')
        .doc(widget.title)
        .collection('cards')
        .snapshots()
        .listen((querySnapshot) {
      _documents = querySnapshot.docs
          .map((doc) => {'id': doc.id, 'data': doc.data()})
          .toList();
      _shuffledDocuments = querySnapshot.docs
          .map((doc) => {'id': doc.id, 'data': doc.data()})
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('widget rebuild in the build context');
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
      // await data['list'].forEach((element) {
      //   _documents.add(element);
      //   _shuffledDocuments.add(element);
      // });
      // _shuffledDocuments.shuffle();
      // print('size: $size');
      // Use the count value here.
    });

    // final db = ref.watch(localFlashcardDBProvider);

    final currentIndex = ref.watch(flashcardIndexProvider);
    // final currentIndex = myBox.get('index');
    // print("size after listen: $size");

    return StreamBuilder(
        stream: flashcardStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("Documents: $_documents");
            print("Shuffled documents: $_shuffledDocuments");
            // print(
            //     'shuffledDoc: $_shuffledDocuments: type: ${_shuffledDocuments.runtimeType}');
            // var shuffledDoc = snapshot.data!['list']..shuffle();
            // List<dynamic> shuffledDoc = snapshot.data!['list'];
            // final size = snapshot.data!['count'];
            final size = _documents.length;
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
                                // TODO: Make this a seperate widget
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
                                      child: PageView.builder(
                                        controller: flashCardController,
                                        itemBuilder: (_, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 150.0,
                                                vertical: 50.0),
                                            child: FlashCard(
                                              // key: UniqueKey(),
                                              title: widget.title,
                                              id: index,
                                              term: ref
                                                      .read(
                                                          isShuffleStateProvider
                                                              .notifier)
                                                      .state
                                                  ? (_shuffledDocuments[index]
                                                      ['data'] as Map)['term']
                                                  : (_documents[index]['data']
                                                      as Map)['term'],
                                              definition: ref
                                                      .read(
                                                          isShuffleStateProvider
                                                              .notifier)
                                                      .state
                                                  ? (_shuffledDocuments[index]
                                                          ['data']
                                                      as Map)['definition']
                                                  : (_documents[index]['data']
                                                      as Map)['definition'],
                                            ),
                                          );
                                        },
                                        itemCount: size,
                                        onPageChanged: (index) {
                                          // ref.read(
                                          //     shuffleStateNotifierProvider);
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
                                  ElevatedButton.icon(
                                      onPressed: () async {
                                        _shuffledDocuments.shuffle();
                                        print(_shuffledDocuments);
                                        ref
                                                .read(isShuffleStateProvider
                                                    .notifier)
                                                .state =
                                            !ref.read(isShuffleStateProvider);
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
                                        // ref
                                        //     .read(
                                        //         flashcardIndexProvider.notifier)
                                        //     .resetIndex();
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
