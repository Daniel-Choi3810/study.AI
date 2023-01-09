import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/controllers/providers/text_controller_providers.dart';
import '../components/home_page/search_field.dart';

// Consumer Stateful Widget is a widget that can be used to read providers
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final answerText = ref
        .watch(answerTextProvider); // Watch for changes in answerTextProvider
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                // Title Text
                'Welcome to IntelliStudy!',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SearchField(
                    textFieldController:
                        _textFieldController), // TODO: REFACTOR THIS SEARCH FIELD TO SEPARATE FILE
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: MaterialButton(
                  // TODO: REFACTOR THIS SEARCH BUTTON TO SEPARATE FILE
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minWidth: 225,
                  onPressed: () async {
                    // TODO: CREATE FUTURE PROVIDER TO WATCH CHANGES IN ANSWER TEXT PROVIDER
                    // answerText.when(
                    //   loading: () => const CircularProgressIndicator(),
                    //   error: (err, stack) => Text('Error: $err'),
                    //   data: (ans) async {
                    //     await ref.read(answerTextProvider.notifier).getText(
                    //         promptText: _textFieldController.text.trim());
                    //   },
                    // );
                    // TODO: REFACTOR THIS METHOD TO SEPARATE FILE
                    if (_textFieldController.text.trim().isNotEmpty) {
                      // If search field is not empty, get answer text with prompt text
                      await ref.read(answerTextProvider.notifier).getText(
                          promptText: _textFieldController.text.trim());
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
              Container(
                // Container to display answer text
                width: 800,
                height: 300,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  answerText.toString(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
