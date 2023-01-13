import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intellistudy/controllers/providers.dart';
import '../components/home_page/formatted_response.dart';
import '../components/home_page/search_field.dart';

// Consumer Stateful Widget is a widget that can be used to read providers
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // ResponsesDataBaseController db = ResponsesDataBaseController();
  final _responseBox = Hive.box('responsesDataBase');

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final db = ref.watch(dbProvider);
    final searchFieldTextController = ref.watch(searchFieldProvider);
    final isLoading =
        ref.watch(isLoadingProvider); // Watch for changes in isLoadingProvider
    final isValid =
        ref.watch(isValidProvider); // Watch for changes in isValidProvider
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 20.0),
          child: FloatingActionButton.extended(
              label: const Text("Clear All",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: () {
                ref.read(dbProvider.notifier).clearList();
              }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("IntelliStudy"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SearchField(
                  width: width,
                  textFieldController: searchFieldTextController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  // TODO: REFACTOR THIS SEARCH BUTTON TO SEPARATE FILE
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minWidth: 225,
                  onPressed: () async {
                    String prompt = searchFieldTextController.text.trim();
                    searchFieldTextController.clear();
                    // print(prompt);
                    //ref.read(answerTextProvider.notifier).clearAnswer();
                    // TODO: REFACTOR THIS METHOD TO SEPARATE FILE
                    if (prompt.isNotEmpty) {
                      ref
                          .read(isValidProvider.notifier)
                          .update((state) => true);
                      // If search field is not empty, get answer text with prompt text
                      await ref
                          .read(answerTextProvider.notifier)
                          .getText(promptText: prompt);
                      // await ref.read(responsesProvider.notifier).addToList(
                      //     term: prompt,
                      //     definition: ref.read(answerTextProvider).toString());
                      await ref.read(dbProvider.notifier).addToList(
                          term: prompt,
                          definition: ref.read(answerTextProvider).toString());
                    } else {
                      // If search field is empty, get answer text with default prompt text
                      ref
                          .read(isValidProvider.notifier)
                          .update((state) => false);
                    }
                    //print(ref.read(responsesProvider));
                  },
                  child: const Text(
                    'Generate Answer',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
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
