import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/controllers/providers/text_controller_providers.dart';
import '../components/home_page/formatted_response.dart';
import '../components/home_page/search_field.dart';

// Consumer Stateful Widget is a widget that can be used to read providers
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final searchFieldText = ref.watch(searchFieldProvider);
    final searchList = ref.watch(responsesProvider);
    final isLoading =
        ref.watch(isLoadingProvider); // Watch for changes in isLoadingProvider
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("IntelliStudy"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SearchField(
                  textFieldController: searchFieldText,
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
                    String prompt = searchFieldText.text.trim();
                    searchFieldText.clear();
                    print(prompt);
                    //ref.read(answerTextProvider.notifier).clearAnswer();
                    // TODO: REFACTOR THIS METHOD TO SEPARATE FILE
                    if (prompt.isNotEmpty) {
                      // If search field is not empty, get answer text with prompt text
                      await ref
                          .read(answerTextProvider.notifier)
                          .getText(promptText: prompt);
                      await ref.read(responsesProvider.notifier).addToList(
                          term: prompt,
                          definition: ref.read(answerTextProvider).toString());
                    } else {
                      // If search field is empty, get answer text with default prompt text
                      ref.read(answerTextProvider.notifier).enterPrompt();
                    }
                  },
                  child: const Text(
                    'Generate Answer',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : const SizedBox(), // If isLoading is true, show CircularProgressIndicator, else show SizedBox
              // Create a scrollable vertical list view
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: searchList
                      .length, // Watch for changes in responsesProvider (list of responses)
                  itemBuilder: ((_, index) {
                    return GestureDetector(
                      onTap: () {
                        print(index);
                      },
                      child: FormattedResponse(
                          height: height,
                          width: width,
                          searchList: searchList,
                          id: index),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
