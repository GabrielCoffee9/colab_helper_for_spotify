import '../../../features/auth/auth_service.dart';
import '../../../models/primary models/user_profile_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retry/retry.dart';

class UserService {
  Dio dio = Dio();
  var storage = const FlutterSecureStorage();

  UserProfile userProfile = UserProfile.instance;

  UserService() {
    dio.options.baseUrl = 'https://api.spotify.com/v1';
  }

  Future<bool> getCurrentUserProfile() async {
    final response = await retry(() async {
      var accessToken = await storage.read(key: 'accessToken');

      return await dio.get(
        '/me',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        }, contentType: Headers.jsonContentType),
      );
    }, retryIf: (e) async {
      if (e is DioException && e.response!.statusMessage == 'Unauthorized') {
        await AuthService().getToken();
        return true;
      }

      return false;
    });

    userProfile.fromJson(response.data);
    return true;
  }
}
