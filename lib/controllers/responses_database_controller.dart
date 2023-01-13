import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final myBox = Hive.box('responsesDataBase');

class ResponsesDataBaseController extends StateNotifier<List> {
  ResponsesDataBaseController() : super([]) {
    loadData();
  }

  void loadData() {
    print(myBox.get('responsesDataBase'));
    if (myBox.get('responsesDataBase') == null) {
      state = [
        ["Example term", "Example definition"]
      ];
      myBox.put('responsesDataBase', state);
    } else {
      state = myBox.get('responsesDataBase');
    }
  }

  Future<void> addToList(
      {required String term, required String definition}) async {
    state = [
      [term, definition],
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
    state[index] = [term, state[index][1]];
    myBox.put('responsesDataBase', state);
  }

  Future<void> editDefinition(
      {required int index, required String definition}) async {
    state[index] = [state[index][0], definition];
    myBox.put('responsesDataBase', state);
  }

  Future<void> clearList() async {
    state = state..clear();
    myBox.put('responsesDataBase', state);
  }
}
