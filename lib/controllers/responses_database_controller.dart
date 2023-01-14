import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intellistudy/controllers/providers.dart';

final myBox = Hive.box('responsesDataBase');

class ResponsesDataBaseController extends StateNotifier<List> {
  final Ref ref;
  ResponsesDataBaseController(this.ref) : super([]) {
    loadData();
  }

  void loadData() {
    print(myBox.get('responsesDataBase'));
    if (myBox.get('responsesDataBase') == null) {
      state = [
        ["Example term", "Example definition", 3]
      ];
      myBox.put('responsesDataBase', state);
    } else {
      state = myBox.get('responsesDataBase');
    }
  }

  Future<void> addToList(
      {required String term, required String definition}) async {
    state = [
      [term, definition, 3],
      ...state,
    ];
    myBox.put('responsesDataBase', state);
  }

  Future<void> removeFromList({required int index}) async {
    // how efficient is this?
    state = state.where((element) => element != state[index]).toList();
    myBox.put('responsesDataBase', state);
  }

  Future<void> editTerm({required int index, required String term}) async {
    state[index] = [term, state[index][1], 3];
    myBox.put('responsesDataBase', state);
    print('term edited: $term');
  }

  Future<void> editDefinition(
      {required int index, required String definition}) async {
    state[index] = [state[index][0], definition, 3];
    myBox.put('responsesDataBase', state);
    print('definition edited: $definition');
  }

  Future<void> placeCurrentResponse({required int index}) async {
    state[index] = [state[index][0], state[index][1], state[index][2]];
    myBox.put('responsesDataBase', state);
  }

  Future<void> regenerateResponse({
    required int index,
    required String term,
  }) async {
    // if (state[index][2] > 0) {
    //   await ref.read(answerTextProvider.notifier).getText(promptText: term);
    //   state[index] = [
    //     term,
    //     ref.read(answerTextProvider).toString(),
    //     state[index][2] - 1
    //   ];
    //   ref.read(responsesCountProvider.notifier).state = state[index][2];
    //   myBox.put('responsesDataBase', state);
    // ref.read(responsesCountProvider.notifier).state--;
    await ref.read(answerTextProvider.notifier).getText(promptText: term);
    state[index] = [
      term,
      ref.read(answerTextProvider).toString(),
      state[index][2] - 1
    ];
    myBox.put('responsesDataBase', state);

    print(state[index][2]);
  }

  Future<void> clearList() async {
    state = [];
    myBox.put('responsesDataBase', state);
  }
}
