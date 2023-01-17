import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/view/components/flash_card/flash_card.dart';
import '../../providers/providers.dart';

class FlashCardViewPage extends ConsumerStatefulWidget {
  const FlashCardViewPage({super.key});

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
    final db = ref.watch(dbProvider);
    final currentIndex = ref.watch(flashcardIndexStateProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        label: const Text('Back to Home page'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.8,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width * 0.9),
                child: PageView.builder(
                    controller: flashCardController,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 150.0, vertical: 50.0),
                        child: FlashCard(
                            term: db[index][0], definition: db[index][1]),
                      );
                    },
                    itemCount: db.length,
                    onPageChanged: (index) {
                      ref.read(flashcardIndexStateProvider.notifier).state =
                          index;
                    }),
              ),
            ),
            // FlashCard(
            //     term: db[currentIndex][0], definition: db[currentIndex][1]),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
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
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.linear);
                      },
                      icon: const Icon(Icons.chevron_left),
                      label: const Text('Prev'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (currentIndex + 1 < db.length) {
                          ref
                              .read(flashcardIndexStateProvider.notifier)
                              .state++;
                        }
                        print(
                            "Current index after pressing next: $currentIndex");
                        flashCardController.animateToPage(
                            ref.read(flashcardIndexStateProvider),
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.linear);
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
