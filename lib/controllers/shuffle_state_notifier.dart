import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShuffleStateNotifier extends StateNotifier<List<dynamic>> {
  final Ref ref;
  final List<dynamic> _data;
  // ShuffleStateNotifier(this.ref, data) : super([],);

  ShuffleStateNotifier(this.ref, List<dynamic> data)
      : _data = data,
        super(data);

// AuthController({required AuthRepository authRepository, required Ref ref})
//       : _authRepository = authRepository,
//         _ref = ref,
//         super(false);
  // get data parameter from class

  void shuffle() {
    state = _data..shuffle();
    state = state;
    print(state);
  }
}
