import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intellistudy/providers/providers.dart';
import 'package:intellistudy/view/components/flash_card/flash_card.dart';
import 'package:intellistudy/view/components/flashcard_create_page/clear_all_dialog/clear_all_alert_cards_dialog.dart';
import 'package:intellistudy/view/pages/flashcard_master_view_page.dart';
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('              Title: '),
                                SizedBox(
                                  width: width * 0.25,
                                  height: height * 0.05,
                                  child: TextField(
                                    controller: titleTextController,
                                    decoration: const InputDecoration(
                                      hintText: 'Please enter a title',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.01),
                            Row(
                              children: [
                                const Text('Description: '),
                                SizedBox(
                                  width: width * 0.25,
                                  height: height * 0.05,
                                  child: TextField(
                                    controller: descriptionTextController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter a description',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                              hoverElevation: 10,
                              hoverColor:
                                  const Color.fromARGB(255, 63, 50, 179),
                              color: AppColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              minWidth: width * 0.01,
                              height: height * 0.08,
                              child: const Text("Create Flashcard Set"),
                              onPressed: () async {
                                if (titleTextController.text.isNotEmpty &&
                                    titleTextController.text.trim() != ' ' &&
                                    db.length >= 2) {
                                  // titleTextController.clear();
                                  // descriptionTextController.clear();
                                  print('title: ${titleTextController.text}');
                                  print(
                                      'description: ${descriptionTextController.text}');

                                  final setRef = firestore
                                      .collection('flashcardSets')
                                      .doc(
                                          auth.auth.currentUser!.uid.toString())
                                      .collection('sets')
                                      .doc(titleTextController.text.trim());
                                  final setData = {
                                    "title": titleTextController.text.trim(),
                                    "description":
                                        descriptionTextController.text.trim(),
                                    "dateCreated": DateTime.now(),
                                  };
                                  setRef.set(setData).then((documentSnapshot) {
                                    final cardsRef = firestore
                                        .collection('flashcardSets')
                                        .doc(auth.auth.currentUser!.uid
                                            .toString())
                                        .collection('sets')
                                        .doc(titleTextController.text.trim())
                                        .collection('cards');
                                    for (var flashcard in db) {
                                      final data = {
                                        "term": flashcard[0],
                                        "definition": flashcard[1],
                                        "regenerations": flashcard[2],
                                        "isStarred": flashcard[3]
                                      };

                                      cardsRef.add(data).then(
                                          (documentSnapshot) => print(
                                              "Added Data with ID: ${documentSnapshot.id}"));
                                    }
                                  });
                                  await ref
                                      .read(localFlashcardDBProvider.notifier)
                                      .clearList();
                                  if (!mounted) return;
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return FlashcardMasterViewPage(
                                        title: titleTextController.text.trim());
                                  }));
                                }
                              }),
                        ),
                      ],
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
