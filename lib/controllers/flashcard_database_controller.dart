import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intellistudy/providers/providers.dart';

final myBox = Hive.box('flashcardDataBase');

class FlashCardDataBaseController extends StateNotifier<List> {
  final Ref ref;
  FlashCardDataBaseController(this.ref) : super([]) {
    loadData();
  }

  /// state format is as follows:
  /// [term, definition, # of regenerations, isStarred]

  void loadData() {
    print(myBox.get('flashcardDataBase'));
    if (myBox.get('flashcardDataBase') == null) {
      state = [];
      myBox.put('flashcardDataBase', state);
    } else {
      state = myBox.get('flashcardDataBase');
    }
  }

  Future<void> addToList(
      {required String term, required String definition}) async {
    state = [
      [term, definition, 3, false],
      ...state,
    ];
    myBox.put('flashcardDataBase', state);
  }

  Future<void> removeFromList({required int index}) async {
    // how efficient is this?
    state = state.where((element) => element != state[index]).toList();
    myBox.put('flashcardDataBase', state);
  }

  Future<void> editTerm({required int index, required String term}) async {
    state[index] = [term, state[index][1], 3, state[index][3]];
    myBox.put('flashcardDataBase', state);
    print('term edited: $term');
  }

  Future<void> editDefinition(
      {required int index, required String definition}) async {
    state[index] = [state[index][0], definition, 3, state[index][3]];
    myBox.put('flashcardDataBase', state);
    print('definition edited: $definition');
  }

  Future<void> loadPreviousResponse({required int index}) async {
    state[index] = [
      myBox.get('flashcardDataBase')[index][0],
      myBox.get('flashcardDataBase')[index][1],
      myBox.get('flashcardDataBase')[index][2],
      myBox.get('flashcardDataBase')[index][3]
    ];
    myBox.put('flashcardDataBase', state);
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
    //   myBox.put('flashcardDataBase', state);
    // ref.read(responsesCountProvider.notifier).state--;
    if (term.isNotEmpty) {
      await ref.read(answerTextProvider.notifier).getText(promptText: term);
      state[index] = [
        term,
        ref.read(answerTextProvider).toString(),
        state[index][2] - 1,
        state[index][3]
      ];
      myBox.put('flashcardDataBase', state);
    } else {
      // TODO: add some error message or some other way to notify the user
    }
  }

  Future<void> clearList() async {
    state = [];
    myBox.put('flashcardDataBase', state);
  }

  //TODO: These functions are for the flash card view page.  They need to be moved to a different controller with a different hive database.
  Future<void> shuffleList() async {
    state = state.toList()..shuffle();
  }

  Future<void> starCard({required int index}) async {
    state[index][3] = !state[index][3];

    myBox.put('flashcardDataBase', state);
  }

  Future<void> updateStarState({required int index}) async {
    state = [...state];
  }
}
