import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/providers/providers.dart';
import 'package:intellistudy/utils/utils.dart';
import 'package:intellistudy/view/components/header_banner.dart';
import 'package:intellistudy/view/components/page_menu_bar.dart';
import 'package:intellistudy/view/components/search_page/clear_all_dialog/clear_all_button.dart';
import 'package:intellistudy/view/components/search_page/clear_all_dialog/search_clear_all_dialog/search_clear_all_alert_dialog.dart';
import 'package:intellistudy/view/components/search_page/search_card.dart';
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
    final profileState = ref.watch(profileNotifierProvider);

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
      body: SafeArea(
        child: Column(
          children: [
            // MaterialBanner(
            //   content: const Text(
            //       'This is a beta version of the app. Please report any bugs to the developers. Thank you!'),
            //   actions: [
            //     TextButton(onPressed: () {}, child: const Text('Report Bug'))
            //   ],
            // ),
            const PageMenuBar(
              title: "Search Page",
            ),
            const HeaderBanner(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 35.0,
                vertical: 20.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: height * 0.12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 35.0),
                        child: SearchField(
                          height: height,
                          width: width,
                          textFieldController: searchFieldTextController,
                        ),
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
            Expanded(
              child: SingleChildScrollView(
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
                    isLoading
                        ? const Padding(
                            padding: EdgeInsets.only(bottom: 30.0, right: 34.0),
                            child: CircularProgressIndicator(
                              color: AppColors.accentLight,
                            ),
                          )
                        : const SizedBox(), // If isLoading is true, show CircularProgressIndicator, else show SizedBox
                    // Create a scrollable vertical list view
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: db
                          .length, // Watch for changes in responsesProvider (list of responses)
                      itemBuilder: ((_, index) {
                        return SearchCard(
                            question: db[index][0],
                            answer: db[index][1],
                            index: index);
                      }),
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
}
