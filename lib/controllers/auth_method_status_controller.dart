import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Status { login, signUp }

class AuthMethodStatusController extends StateNotifier<Status> {
  Status _status = Status.login;
  final Ref ref; // This is the ref that is used to access the providers

  AuthMethodStatusController(this.ref) : super(Status.login);

  Status get status => _status;

  void changeStatus() {
    if (_status == Status.login) {
      _status = Status.signUp;
    } else {
      _status = Status.login;
    }
    state = _status;
  }
}
