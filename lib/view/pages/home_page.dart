import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intellistudy/providers/providers.dart';
import 'package:intellistudy/view/components/home_page/create_response_button.dart';
import 'package:intellistudy/view/pages/flash_card_view_page.dart';
import '../components/home_page/clear_all_dialog/clear_all_alert_dialog.dart';
import '../components/home_page/formatted_response.dart';
import '../components/home_page/search_field.dart';

// Consumer Stateful Widget is a widget that can be used to read providers
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _responseBox = Hive.box('responsesDataBase');

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final db = ref.watch(dbProvider);
    final searchFieldTextController = ref.watch(searchFieldStateProvider);
    final isLoading = ref.watch(
        isLoadingStateProvider); // Watch for changes in isLoadingProvider
    final isValid =
        ref.watch(isValidStateProvider); // Watch for changes in isValidProvider
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () async {
                    await ref
                        .read(dbProvider.notifier)
                        .addToList(term: '', definition: '');
                  },
                  child: const Icon(Icons.add)),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () async {
                  if (db.length >= 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FlashCardViewPage()),
                    );
                  }
                },
                label: const Text("Create flashcards"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton.extended(
                  heroTag: null,
                  label: const Text("Clear All",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
