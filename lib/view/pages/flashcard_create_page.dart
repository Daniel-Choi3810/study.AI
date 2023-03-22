import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intellistudy/providers/providers.dart';
import 'package:intellistudy/view/components/flashcard_create_page/clear_all_dialog/clear_all_alert_cards_dialog.dart';
import '../../utils/utils.dart';
import '../components/flashcard_create_page/create_response_button.dart';
import '../components/flashcard_create_page/formatted_response.dart';
import '../components/flashcard_create_page/search_field.dart';
import 'login_page.dart';

class FlashCardCreatePage extends ConsumerStatefulWidget {
  const FlashCardCreatePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FlashCardCreatePageState();
}

class _FlashCardCreatePageState extends ConsumerState<FlashCardCreatePage> {
  final flashcardBox = Hive.box('flashcardDataBase');
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final firestore = ref.watch(fireStoreProvider);
    final List db = ref.watch(localFlashcardDBProvider);
    final searchFieldTextController = ref.watch(flashcardFieldStateProvider);
    final isLoading = ref.watch(
        isLoadingStateProvider); // Watch for changes in isLoadingProvider
    final isValid =
        ref.watch(isValidStateProvider); // Watch for changes in isValidProvider
    final titleTextController = ref.watch(setTitleTextStateProvider);
    final descriptionTextController =
        ref.watch(setDescriptionTextStateProvider);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final authState = ref.watch(authStateProvider);
    return Scaffold(
      floatingActionButton: ref.read(authProvider).auth.currentUser == null
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: FloatingActionButton(
                      // TODO: create a custom button
                      heroTag: null,
                      onPressed: () async {
                        await ref
                            .read(localFlashcardDBProvider.notifier)
                            .addToList(term: '', definition: '');
                      },
                      child: const Icon(Icons.add)),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FloatingActionButton.extended(
                      // TODO: create a custom button
                      heroTag: null,
                      label: const Text("Clear All",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        if (db.isNotEmpty) {
                          showClearAlertCardsDialog(context, ref);
                        }
                      }),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: false,
      body: authState.when(
        data: (data) {
          if (data != null) {
            return SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: height * 0.05,
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
                        height: height * .3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, left: 35.0),
                              child: Text(
                                'Title',
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 35.0, right: 35.0),
                                child: TextField(
                                  controller: titleTextController,
                                  decoration: const InputDecoration(
                                    hintText: 'Please enter a title',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 35.0),
                              child: Text(
                                'Description',
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 35.0, right: 35.0),
                                child: TextField(
                                  controller: descriptionTextController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter a description',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 35.0, top: 20.0, bottom: 15.0),
                                child: MaterialButton(
                                    hoverElevation: 10,
                                    hoverColor:
                                        const Color.fromARGB(255, 63, 50, 179),
                                    color: AppColors.complementary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    minWidth: width * 0.03,
                                    height: height * 0.08,
                                    child: const Text(
                                      "Create Flashcard Set",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      print(
                                          "Current user is: ${auth.auth.currentUser!.uid}");
                                      if (titleTextController.text.isNotEmpty &&
                                          titleTextController.text.trim() !=
                                              ' ' &&
                                          db.length >= 2) {
                                        // titleTextController.clear();
                                        // descriptionTextController.clear();
                                        print(
                                            'title: ${titleTextController.text}');
                                        print(
                                            'description: ${descriptionTextController.text}');

                                        final setRef = firestore
                                            .collection('flashcardSets')
                                            .doc(auth.auth.currentUser!.uid
                                                .toString())
                                            .collection('sets')
                                            .doc(titleTextController.text
                                                .trim());

                                        await firestore
                                            .collection('flashcardSets')
                                            .doc(auth.auth.currentUser!.uid
                                                .toString())
                                            .set(
                                          {
                                            'id': auth.auth.currentUser!.uid
                                                .toString(),
                                            'email':
                                                auth.auth.currentUser!.email,
                                            'username': auth
                                                .auth.currentUser!.displayName,
                                          },
                                        );

                                        final setData = {
                                          "title":
                                              titleTextController.text.trim(),
                                          "description":
                                              descriptionTextController.text
                                                  .trim(),
                                          "dateCreated": DateTime.now(),
                                        };
                                        await setRef
                                            .set(setData)
                                            .then((documentSnapshot) {
                                          final cardsRef = firestore
                                              .collection('flashcardSets')
                                              .doc(auth.auth.currentUser!.uid
                                                  .toString())
                                              .collection('sets')
                                              .doc(titleTextController.text
                                                  .trim())
                                              .collection('cards');
                                          // for (var flashcard in db) {
                                          //   final data = {
                                          //     "term": flashcard[0],
                                          //     "definition": flashcard[1],
                                          //     "regenerations": flashcard[2],
                                          //     "isStarred": flashcard[3]
                                          //   };

                                          //   cardsRef.add(data).then(
                                          //       (documentSnapshot) => print(
                                          //           "Added Data with ID: ${documentSnapshot.id}"));
                                          // }

                                          for (int i = 0; i < db.length; i++) {
                                            final data = {
                                              "term": db[i][0],
                                              "definition": db[i][1],
                                              "regenerations": db[i][2],
                                              "isStarred": db[i][3],
                                              "dateExample": Timestamp.now(),
                                            };

                                            cardsRef.doc().set(data);
                                          }
                                        });
                                        await ref
                                            .read(localFlashcardDBProvider
                                                .notifier)
                                            .clearList();
                                        if (!mounted) return;
                                        await Navigator.pushNamed(
                                            context, '/flashcardMasterView',
                                            arguments: titleTextController.text
                                                .trim());
                                        ref
                                            .read(setTitleTextStateProvider)
                                            .clear();
                                        ref
                                            .read(
                                                setDescriptionTextStateProvider)
                                            .clear();
                                      }
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SearchField(
                        height: height,
                        width: width,
                        textFieldController: searchFieldTextController,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CreateResponseButton(
                          searchFieldTextController: searchFieldTextController),
                    ),
                    isValid
                        ? const SizedBox(
                            height: 18,
                          )
                        : const SizedBox(
                            height: 18,
                            child: Text(
                              'Please enter a valid prompt',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                    isLoading
                        ? const CircularProgressIndicator()
                        : const SizedBox(), // If isLoading is true, show CircularProgressIndicator, else show SizedBox
                    SizedBox(
                      height: height * 0.06,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35.0,
                        vertical: 20.0,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text('My Flashcards'),
                                )),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 35.0, top: 20.0, bottom: 15.0),
                                child: MaterialButton(
                                    hoverElevation: 10,
                                    hoverColor:
                                        const Color.fromARGB(255, 63, 50, 179),
                                    color: AppColors.accentLight,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    minWidth: width * 0.09,
                                    height: height * 0.07,
                                    child: const Text(
                                      "Add",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {}),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 35.0, top: 20.0, bottom: 15.0),
                                child: MaterialButton(
                                    hoverElevation: 10,
                                    hoverColor:
                                        const Color.fromARGB(255, 63, 50, 179),
                                    color: AppColors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    minWidth: width * 0.09,
                                    height: height * 0.07,
                                    child: const Text(
                                      "Add",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {}),
                              ),
                            ),
                          ]),
                    ),
                    // Create a scrollable vertical list view
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: db
                          .length, // Watch for changes in responsesProvider (list of responses)
                      itemBuilder: ((_, index) {
                        return FormattedResponse(
                            key:
                                UniqueKey(), //TODO: Figure this out, why does valueKey Not work?
                            height: height,
                            width: width,
                            searchList: db,
                            id: index);
                      }),
                    ),
                  ],
                ),
              ),
            );
          }
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 2,
              sigmaY: 2,
            ),
            child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                height: height * 0.75,
                width: width * 0.75,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: const LoginPage(),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stackTrace) => Center(
          child: Text(
            e.toString(),
          ),
        ),
      ),
    );
  }
}
