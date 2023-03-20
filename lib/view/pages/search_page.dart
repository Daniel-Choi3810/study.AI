import 'package:auto_size_text/auto_size_text.dart';
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
                height: height * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Expanded(
                      flex: 4,
                      child: AutoSizeText(
                        'Search Page',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    MaterialButton(
                      hoverElevation: 10,
                      hoverColor: AppColors.complementaryDark,
                      color: AppColors.complementary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minWidth: width * 0.1,
                      height: height * 0.065,
                      onPressed: () {},
                      child: const Text(
                        'Subscription Plans',
                        style: TextStyle(
                          fontSize: 16,
                          //fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          profileState == 'Guest'
                              ? const Icon(Icons.person)
                              : CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Text(profileState[0].toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(child: Text(profileState)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PopupMenuButton(
                          itemBuilder: (context) => [
                                const PopupMenuItem(child: Text('Profile')),
                                profileState == 'Guest'
                                    ? PopupMenuItem(
                                        child: TextButton(
                                          child: const Text('Log In'),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/login');
                                          },
                                        ),
                                      )
                                    : PopupMenuItem(
                                        onTap: () async {
                                          await auth.signOut();
                                          ref
                                              .read(profileNotifierProvider
                                                  .notifier)
                                              .changeProfileStatus();
                                        },
                                        child: const Text('Sign Out'),
                                      ),
                              ]),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 35.0,
                vertical: 8.0,
              ),
              child: Container(
                height: height * 0.2,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(80, 148, 160, 255),
                      Color.fromARGB(69, 223, 159, 234)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        AutoSizeText(
                          "Welcome to Cram.AI!",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: 150,
                          child: AutoSizeText(
                            textAlign: TextAlign.left,
                            "Sign up for a free account to create your own flashcards and study sets.",
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(width: 50),
                    Image.asset(
                      "assets/Banner-Image.png",
                      width: 175.0,
                      height: 175.0,
                      fit: BoxFit.cover,
                    ),
                    // Image.asset("assets/Ground-Vector.png",
                    //     width: 200.0, height: 200.0),
                  ],
                ),
              ),
            ),
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
                height: height * 0.16,
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
                    isLoading // TODO: Make loading indicator container match the size of the cards
                        ? const Padding(
                            padding: EdgeInsets.only(bottom: 30.0, right: 34.0),
                            child: CircularProgressIndicator(
                              color: AppColors.accentLight,
                            ),
                          )
                        : const SizedBox(), // If isLoading is true, show CircularProgressIndicator, else show SizedBox
                    // Create a scrollable vertical list view
                    Column(
                      children: [
                        ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: db
                              .length, // Watch for changes in responsesProvider (list of responses)
                          itemBuilder: ((_, index) {
                            return Padding(
                              // TODO: Refactor this response card to a custom widget
                              padding: const EdgeInsets.only(
                                  left: 35.0, bottom: 16.0, right: 35.0),
                              child: Container(
                                height: height * 0.15,
                                decoration: BoxDecoration(
                                  // border: Border.all(
                                  //   color: AppColors.complementary,
                                  //   width: 1,
                                  // ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 3, right: 10),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () async {
                                            await ref
                                                .read(localSearchDBProvider
                                                    .notifier)
                                                .removeFromList(index: index);
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: AppColors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 50.0,
                                          right: 50.0,
                                        ),
                                        child: AutoSizeText(
                                          db[index][0],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50.0,
                                            right: 50.0,
                                            bottom: 10.0),
                                        child: AutoSizeText(
                                          db[index][1],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
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
