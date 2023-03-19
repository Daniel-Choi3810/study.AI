import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final myBox = Hive.box('flashcardIndexDataBase');

class FlashCardIndexControllerNotifier extends StateNotifier<int> {
  final Ref ref;
  FlashCardIndexControllerNotifier(this.ref) : super(0) {
    loadData();
  }

  /// state format is as follows:
  /// [term, definition, # of regenerations, isStarred]

  void loadData() {
    print(myBox.get('index'));
    if (myBox.get('index') == null) {
      state = 0;
      myBox.put('index', state);
    } else {
      state = myBox.get('index');
    }
  }

  int getIndex() {
    state = myBox.get('index');
    return state;
  }

  void incrementIndex() {
    state++;
    myBox.put('index', state);
  }

  void decrementIndex() {
    state--;
    myBox.put('index', state);
  }

  void resetIndex() {
    state = 0;
    myBox.put('index', state);
  }

  void setIndex({required int index}) {
    state = index;
    myBox.put('index', state);
  }
}
