import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final myBox = Hive.box('responsesDataBase');

class SearchDataBaseControllerNotifier extends StateNotifier<List> {
  final Ref ref;
  SearchDataBaseControllerNotifier(this.ref) : super([]) {
    loadData();
  }

  /// state format is as follows:
  /// [term, definition, # of regenerations, isStarred]

  void loadData() {
    print(myBox.get('responsesDataBase'));
    if (myBox.get('responsesDataBase') == null) {
      state = [];
      myBox.put('responsesDataBase', state);
    } else {
      state = myBox.get('responsesDataBase');
    }
  }

  Future<void> addToList(
      {required String term, required String definition}) async {
    state = [
      [term, definition, 3, false],
      ...state,
    ];
    myBox.put('responsesDataBase', state);
  }

  Future<void> removeFromList({required int index}) async {
    // how efficient is this?
    state = state.where((element) => element != state[index]).toList();
    myBox.put('responsesDataBase', state);
  }

  Future<void> loadPreviousResponse({required int index}) async {
    state[index] = [
      myBox.get('responsesDataBase')[index][0],
      myBox.get('responsesDataBase')[index][1],
      myBox.get('responsesDataBase')[index][2],
      myBox.get('responsesDataBase')[index][3]
    ];
    myBox.put('responsesDataBase', state);
  }

  Future<void> clearList() async {
    state = [];
    myBox.put('responsesDataBase', state);
  }
}
