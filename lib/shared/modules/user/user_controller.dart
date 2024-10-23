import 'user_service.dart';

import 'package:flutter/material.dart';

enum UserState { idle, success, error, loading }

class UserController {
  var state = ValueNotifier(UserState.idle);

  UserController();

  String? lastError;

  Future<bool> getUserProfile() async {
    try {
      state.value = UserState.loading;
      await UserService().getCurrentUserProfile();
    } on Exception catch (error) {
      lastError = error.toString();
      state.value = UserState.error;
      return false;
    }
    state.value = UserState.success;
    lastError = '';
    return true;
  }

  Future<String> getUserUrlProfileImage(userId) async {
    try {
      var result = await UserService().getUserUrlProfileImage(userId);
      return result;
    } on Exception catch (error) {
      lastError = error.toString();
      state.value = UserState.error;

      return 'Error';
    }
  }
}
