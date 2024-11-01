import '../network/http.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  var storage = const FlutterSecureStorage();

  final dio = Http.instance.dio;

  Future<Response<dynamic>> getCurrentUserProfile() async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/me',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }

  Future<Response<dynamic>> getUserUrlProfileImage(userId) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/users/$userId',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return response;
    } on Exception {
      rethrow;
    }
  }
}
