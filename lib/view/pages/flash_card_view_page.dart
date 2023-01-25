import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../components/flash_card/flash_card.dart';

class FlashCardViewPage extends ConsumerStatefulWidget {
  const FlashCardViewPage({required this.title, super.key});
  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FlashCardViewPageState();
}

class _FlashCardViewPageState extends ConsumerState<FlashCardViewPage> {
  PageController flashCardController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final auth = ref.watch(authProvider);
    final firestore = ref.watch(fireStoreProvider);
    final db = ref.watch(localFlashcardDBProvider);
    final currentIndex = ref.watch(flashcardIndexStateProvider);
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            ref
                .read(localFlashcardDBProvider.notifier)
                .updateStarState(index: currentIndex);
            Navigator.pop(context);
          },
          label: const Text('Back to Home page'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: currentIndex == db.length
                  ? Text('$currentIndex / ${db.length}')
                  : Text('${currentIndex + 1} / ${db.length}'),
            ),
            LinearProgressIndicator(
              minHeight: 2,
              value: (currentIndex) / db.length,
              backgroundColor: Colors.grey,
            ),
            Column(
              children: [
                // SizedBox(
                //   height: height * 0.1,
                // ),
                currentIndex == db.length
                    ? Column(
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
                                          '$currentIndex / ${db.length} studied')
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
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.restart_alt_rounded,
                                        size: 30,
                                      )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.home,
                                        size: 30,
                                      )),
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
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 150.0, vertical: 50.0),
                                      child: FlashCard(
                                          key: UniqueKey(),
                                          id: index,
                                          term: db[index][0],
                                          definition: db[index][1]),
                                    );
                                  },
                                  itemCount: db.length,
                                  onPageChanged: (index) {
                                    ref
                                        .read(flashcardIndexStateProvider
                                            .notifier)
                                        .state = index;
                                  }),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
            currentIndex == db.length
                ? const SizedBox()
                : Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              if (currentIndex - 1 >= 0) {
                                ref
                                    .read(flashcardIndexStateProvider.notifier)
                                    .state--;
                              }
                              print(
                                  "Current index after pressing prev: $currentIndex");

                              flashCardController.animateToPage(
                                  ref.read(flashcardIndexStateProvider),
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.linear);
                            },
                            icon: const Icon(Icons.chevron_left),
                            label: const Text('Prev'),
                          ),
                          ElevatedButton.icon(
                              onPressed: () async {
                                await ref
                                    .read(localFlashcardDBProvider.notifier)
                                    .shuffleList();
                              },
                              icon: const Icon(Icons.shuffle),
                              label: const Text('Shuffle')),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (currentIndex + 1 < db.length) {
                                ref
                                    .read(flashcardIndexStateProvider.notifier)
                                    .state++;
                                print(
                                    "Current index after pressing next: $currentIndex");
                                flashCardController.animateToPage(
                                    ref.read(flashcardIndexStateProvider),
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.linear);
                              } else {
                                ref
                                    .read(flashcardIndexStateProvider.notifier)
                                    .state++;
                              }
                            },
                            icon: const Icon(Icons.chevron_right),
                            label: const Text('Next'),
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
