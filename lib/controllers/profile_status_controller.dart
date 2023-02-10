import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class ProfileStatusController extends StateNotifier<String> {
  final Ref ref; // This is the ref that is used to access the providers
  String _profile = '';
  ProfileStatusController(this.ref)
      : super(
          ref.read(authProvider).auth.currentUser != null
              ? ref.read(authProvider).auth.currentUser!.email!
              : 'Guest',
        ); // : super('Guest');

  String get profile => _profile;

  void changeProfileStatus() {
    final auth = ref.read(authProvider);

    if (auth.auth.currentUser != null) {
      _profile = auth.auth.currentUser!.email!;
    } else {
      _profile = 'Guest';
    }
    state = _profile;
  }
}
