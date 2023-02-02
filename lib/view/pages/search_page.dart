import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/providers/providers.dart';
import 'package:intellistudy/utils/utils.dart';
import 'package:intellistudy/view/components/search_page/clear_all_dialog/clear_all_button.dart';
import 'package:intellistudy/view/components/search_page/clear_all_dialog/search_clear_all_dialog/search_clear_all_alert_dialog.dart';
import '../components/flashcard_create_page/search_field.dart';
import '../components/search_page/create_search_response_button.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final db = ref.watch(
        localSearchDBProvider); // Watch for changes in local searchpage Hive DB
    final searchFieldTextController = ref.watch(
        searchFieldStateProvider); // Watch for changes in searchFieldTextController
    final isLoading = ref.watch(
        searchIsLoadingStateProvider); // Watch for changes in isLoadingProvider
    final isValid = ref.watch(
        searchIsValidStateProvider); // Watch for changes in isValidProvider
    final auth = ref.watch(authProvider); // Watch for changes in authProvider
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ClearAllButton(onPressed: () {
          // Clear all button for clearing all search results
          if (db.isNotEmpty) {
            // If the search results are not empty, show the clear all dialog
            showSearchAlertDialog(context, ref);
          }
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: false,
      // appBar: AppBar( // TODO: Add all navigational functionality to side nav bar
      //   backgroundColor: Colors.black,
      //   centerTitle: true,
      //   title: const Text("Search browser page "),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: TextButton.icon(
      //         label: const Text(
      //           'Logout',
      //           style: TextStyle(color: Colors.white),
      //         ),
      //         onPressed: () async {
      //           await auth.signOut();
      //         },
      //         icon: const Icon(
      //           Icons.logout,
      //           color: Colors.white,
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: TextButton.icon(
      //           label: const Text('Create Flashcards',
      //               style: TextStyle(color: Colors.white)),
      //           onPressed: () async {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) => const FlashCardCreatePage()),
      //             );
      //           },
      //           icon: const Icon(
      //             Icons.card_giftcard,
      //             color: Colors.white,
      //           )),
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.125,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SearchField(
                        height: height,
                        width: width,
                        textFieldController: searchFieldTextController,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 35.0),
                      child: SearchButton(
                          height: height,
                          width: width,
                          searchFieldTextController: searchFieldTextController),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  isValid
                      ? SizedBox(
                          height: height * 0.02,
                        )
                      : SizedBox(
                          height: height * 0.05,
                          child: const Text(
                            'Please enter a valid prompt',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                  isLoading // TODO: Make loading indicator container match the size of the cards
                      ? Padding(
                          padding:
                              const EdgeInsets.only(bottom: 30.0, right: 34.0),
                          child: Container(
                            height: height * 0.08,
                            width: width * 0.785,
                            decoration: BoxDecoration(
                              color: AppColors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const SizedBox(
                              width: 5,
                              height: 5,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.purple,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(), // If isLoading is true, show CircularProgressIndicator, else show SizedBox
                  // Create a scrollable vertical list view
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: db
                        .length, // Watch for changes in responsesProvider (list of responses)
                    itemBuilder: ((_, index) {
                      return Padding(
                        // TODO: Refactor this response card to a custom widget
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 16.0, right: 34.0),
                        child: Container(
                          height: height * 0.15,
                          width: 300,
                          decoration: BoxDecoration(
                            color: AppColors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(db[index][0]),
                              Text(db[index][1]),
                              IconButton(
                                  onPressed: () async {
                                    await ref
                                        .read(localSearchDBProvider.notifier)
                                        .removeFromList(index: index);
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
