import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListViewNotifier extends StateNotifier<List<List<String>>> {
  // This is the controller for the list

  ListViewNotifier() : super([]);

  Future<void> addToList(
      {required String term, required String definition}) async {
    state = [
      [term, definition],
      ...state,
    ];
  }

  Future<void> removeFromList({required int index}) async {
    // how efficient is this?
    print("Initial state: $state");
    print("Index to be removed: ${state[index]}");
    state = state.where((element) => element != state[index]).toList();
    print("Final state: $state");
    // state = state..removeAt(index);
  }

  Future<void> editTerm({
    required int index,
    required String term,
  }) async {
    state[index] = [term, state[index][1]];
  }

  Future<void> editDefinition(
      {required int index, required String definition}) async {
    state[index] = [state[index][0], definition];
  }

  Future<void> clearList() async {
    state = [];
  }
}
