import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListViewNotifier extends StateNotifier<List<List<String>>> {
  // This is the controller for the list

  ListViewNotifier() : super([]);

  void addToList({required String term, required String definition}) async {
    state = [
      ...state,
      [term, definition]
    ];
  }

  Future<void> removeFromList({required int index}) async {
    // how efficient is this?
    state = state.where((element) => element != state[index]).toList();
    // state = state..removeAt(index);
  }

  void editList(
      {required int index,
      required String term,
      required String definition}) async {
    state[index] = [term, definition];
  }
}
