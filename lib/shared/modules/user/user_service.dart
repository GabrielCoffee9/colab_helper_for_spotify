import '../../../models/primary models/user_profile_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  Dio dio = Dio();
  var storage = const FlutterSecureStorage();

  UserProfile userProfile = UserProfile.instance;

  UserService() {
    dio.options.baseUrl = 'https://api.spotify.com/v1';
  }

  Future<bool> getCurrentUserProfile() async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/me',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      userProfile.fromJson(response.data);
      return true;
    } on Exception {
      rethrow;
    }
  }

  Future<String> getUserUrlProfileImage(userId) async {
    var accessToken = await storage.read(key: 'accessToken');
    final response = await dio.get(
      '/users/$userId',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    List<dynamic> imagesList = response.data['images'];
    if (imagesList.isNotEmpty) {
      return response.data['images'][0]['url'];
    } else {
      return '';
    }
  }
}
