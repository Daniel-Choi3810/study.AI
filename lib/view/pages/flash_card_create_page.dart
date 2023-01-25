import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intellistudy/providers/providers.dart';
import 'package:intellistudy/view/components/flashcard_create_page/create_response_button.dart';
import '../components/flashcard_create_page/clear_all_dialog/clear_all_alert_dialog.dart';
import '../components/flashcard_create_page/formatted_response.dart';
import '../components/flashcard_create_page/search_field.dart';

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
    return Scaffold(
      floatingActionButton: ref.read(authProvider).auth.currentUser == null
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: FloatingActionButton(
                      heroTag: null,
                      onPressed: () async {
                        await ref
                            .read(localFlashcardDBProvider.notifier)
                            .addToList(term: '', definition: '');
                      },
                      child: const Icon(Icons.add)),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(30.0),
                //   child: FloatingActionButton.extended(
                //     heroTag: null,
                //     onPressed: () async {
                //       if (db.length >= 2) {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => const FlashCardViewPage()),
                //         );
                //       }
                //     },
                //     label: const Text("Create flashcards"),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FloatingActionButton.extended(
                      heroTag: null,
                      label: const Text("Clear All",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        if (db.isNotEmpty) {
                          showAlertDialog(context, ref);
                        }
                      }),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Flash Card Generate Page"),
        actions: const [],
      ),
      body:
          // auth.auth.currentUser == null
          //     ? AlertDialog(
          //         contentPadding: EdgeInsets.zero,
          //         content: Container(
          //           height: height * 0.9,
          //           width: width * 0.9,
          //           decoration: const BoxDecoration(
          //             borderRadius: BorderRadius.all(Radius.circular(20.0)),
          //           ),
          //           child: const LoginPage(),
          //         ),
          //       )
          //     :
          SafeArea(
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
                    child: FloatingActionButton.extended(
                        label: const Text("Create Flashcard Set"),
                        onPressed: () async {
                          List<String> titles = [];
                          final setsRef = firestore
                              .collection('flashcardSets')
                              .doc(auth.auth.currentUser!.uid.toString())
                              .collection('sets');
                          final setsSnapshot = await setsRef.get();
                          for (var doc in setsSnapshot.docs) {
                            titles.add(doc['title']);
                          }
                          print(titles);

                          if (titleTextController.text.isNotEmpty &&
                              titleTextController.text.trim() != ' ' &&
                              db.length >= 2 &&
                              !titles.contains(titleTextController.text)) {
                            // titleTextController.clear();
                            // descriptionTextController.clear();
                            print('title: ${titleTextController.text}');
                            print(
                                'description: ${descriptionTextController.text}');
                            List<Map> flashcardList = db
                                .map((flashcard) => {
                                      'term': flashcard[0],
                                      'definition': flashcard[1],
                                      'regenerations': flashcard[2],
                                      'isStarred': flashcard[3],
                                    })
                                .toList();

                            print("The flashcard list is: $flashcardList");
                            // await firestore
                            //     .collection('users')
                            //     .doc(auth.auth.currentUser!.uid.toString())
                            //     .collection('flashcardSets')
                            //     .doc()
                            //     .set({

                            // });
                            await firestore
                                .collection('flashcardSets')
                                .doc(auth.auth.currentUser!.uid.toString())
                                .set({});

                            await firestore
                                .collection('flashcardSets')
                                .doc(auth.auth.currentUser!.uid.toString())
                                .collection('sets')
                                .doc(titleTextController.text.trim())
                                .set({
                              'title': titleTextController.text.trim(),
                              'description':
                                  descriptionTextController.text.isEmpty
                                      ? ' '
                                      : descriptionTextController.text.trim(),
                              'dateCreated': DateTime.now().toString(),
                              'flashcards': flashcardList,
                            });
                          }
                        }),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SearchField(
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
      ),
    );
  }
}
