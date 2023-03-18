import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final shuffleBox = Hive.box('flashcardIsShuffledDataBase');

class IsShuffleControllerNotifier extends StateNotifier<bool> {
  final Ref ref;
  IsShuffleControllerNotifier(this.ref) : super(false) {
    loadData();
  }

  /// state format is as follows:
  /// [term, definition, # of regenerations, isStarred]

  void loadData() {
    // print(myBox.get('isShuffled'));
    if (shuffleBox.get('isShuffle') == null) {
      state = false;
      shuffleBox.put('isShuffle', state);
    } else {
      state = shuffleBox.get('isShuffle');
    }
  }

  void clearData() {
    state = false;
    shuffleBox.put('isShuffle', state);
  }

  Future<void> toggleIsShuffled() async {
    state = !state;
    shuffleBox.put('isShuffle', state);
  }
}
