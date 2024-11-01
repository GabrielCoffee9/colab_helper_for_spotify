import '../../../models/primary models/user_profile_model.dart';
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
      final response = await UserService().getCurrentUserProfile();

      UserProfile userProfile = UserProfile.instance;

      userProfile.fromJson(response.data);
    } on Exception catch (error) {
      lastError = error.toString();
      state.value = UserState.error;
      return false;
    }
    state.value = UserState.success;
    lastError = '';
    return true;
  }

  Future<String> getUserUrlProfileImage(String? userId) async {
    try {
      if (userId == null || userId.isEmpty) {
        lastError =
            'the given userId at getUserUrlProfileImage is null or empty';
        state.value = UserState.error;
        return '';
      }

      var response = await UserService().getUserUrlProfileImage(userId);

      List<dynamic> imagesList = response.data['images'];
      if (imagesList.isNotEmpty) {
        return response.data['images'][0]['url'];
      } else {
        return '';
      }
    } on Exception catch (error) {
      lastError = error.toString();
      state.value = UserState.error;

      return 'Error';
    }
  }
}
