import 'package:colab_helper_for_spotify/features/auth/auth_controller.dart';
import 'package:retry/retry.dart';
import 'package:colab_helper_for_spotify/models/primary models/user_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum UserState { idle, success, error, loading }

class UserController extends ChangeNotifier {
  var state = UserState.idle;

  UserProfile userProfile = UserProfile();
  Dio dio = Dio();
  var storage = const FlutterSecureStorage();

  UserController() {
    dio.options.baseUrl = 'https://api.spotify.com/v1';
  }

  getCurrentUserProfile() async {
    final response = await retry(() async {
      state = UserState.loading;
      notifyListeners();

      var accessToken = await storage.read(key: 'accessToken');

      return await dio
          .get(
            '/me',
            options: Options(headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json'
            }, contentType: Headers.jsonContentType),
          )
          .timeout(const Duration(seconds: 5));
    }, retryIf: (e) async {
      if (e is DioError && e.response!.statusMessage == 'Unauthorized') {
        await AuthController().getToken();
        return true;
      }

      state = UserState.error;
      notifyListeners();
      return false;
    });

    if (state != UserState.error) {
      userProfile = UserProfile.fromJson(response.data);

      state = UserState.success;
      notifyListeners();
    }
  }
}
