import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/controllers/providers/text_controller_providers.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final answerText = ref.watch(answerTextProvider);
    final isLoading = ref.watch(isLoadingProvider);
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
                'Welcome to IntelliStudy!',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: 10.0,
                      ),
                      child: Icon(
                        Icons.search_rounded,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    hintText: 'Enter your question...',
                    hintStyle: TextStyle(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: MaterialButton(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minWidth: 225,
                  onPressed: () async {
                    // answerText.when(
                    //   loading: () => const CircularProgressIndicator(),
                    //   error: (err, stack) => Text('Error: $err'),
                    //   data: (ans) async {
                    //     await ref.read(answerTextProvider.notifier).getText(
                    //         promptText: _textFieldController.text.trim());
                    //   },
                    // );
                    // print("$isLoading before await call");
                    if (_textFieldController.text.trim().isNotEmpty) {
                      await ref.read(answerTextProvider.notifier).getText(
                          promptText: _textFieldController.text.trim());
                    } else {
                      ref.read(answerTextProvider.notifier).enterPrompt();
                    }

                    // print("$isLoading after await call");
                  },
                  child: const Text(
                    'Generate Answer',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              isLoading ? const CircularProgressIndicator() : const SizedBox(),
              Container(
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
