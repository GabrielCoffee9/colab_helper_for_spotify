import 'user_service.dart';

import 'package:flutter/material.dart';

enum UserState { idle, success, error, loading }

class UserController extends ChangeNotifier {
  var state = ValueNotifier(UserState.idle);

  UserController();

  Future<bool> getUserProfile() async {
    try {
      state.value = UserState.loading;
      await UserService().getCurrentUserProfile();
    } catch (e) {
      state.value = UserState.error;
      state.value = UserState.idle;
      return false;
    }
    state.value = UserState.success;
    return true;
  }
}
