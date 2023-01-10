import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListViewNotifier extends StateNotifier<List<List<String>>> {
  // This is the controller for the list

  ListViewNotifier() : super([]);

  void updateList({required String term, required String definition}) async {
    state = [
      ...state,
      [term, definition]
    ];
  }
}
