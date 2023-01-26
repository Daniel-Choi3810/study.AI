import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intellistudy/providers/providers.dart';
import 'package:intellistudy/view/components/search_page/clear_all_dialog/search_clear_all_dialog/search_clear_all_alert_dialog.dart';
import 'package:intellistudy/view/components/search_page/create_search_response_button.dart';
import 'package:intellistudy/view/pages/flashcard_create_page.dart';
import '../components/flashcard_create_page/search_field.dart';

// Consumer Stateful Widget is a widget that can be used to read providers
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _responseBox = Hive.box('responsesDataBase');
  // final myBox = Hive.box('isAuthenticated');

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final db = ref.watch(localSearchDBProvider);
    final searchFieldTextController = ref.watch(searchFieldStateProvider);
    final isLoading = ref.watch(
        searchIsLoadingStateProvider); // Watch for changes in isLoadingProvider
    final isValid = ref.watch(
        searchIsValidStateProvider); // Watch for changes in isValidProvider
    final auth = ref.watch(authProvider);
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton.extended(
            heroTag: null,
            label: const Text("Clear All",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: () {
              if (db.isNotEmpty) {
                showSearchAlertDialog(context, ref);
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Search browser page "),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await auth.signOut();
                // if (!mounted) return;
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const LoginPage()),
                // );
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
                label: const Text('Create Flashcards',
                    style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FlashCardCreatePage()),
                  );
                },
                icon: const Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                )),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                child: SearchButton(
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
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: height * 0.15,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.black,
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
      ),
    );
  }
}
