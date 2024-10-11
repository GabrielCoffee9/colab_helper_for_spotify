import 'dart:developer';

import 'package:colab_helper_for_spotify/features/auth/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retry/retry.dart';

class PlayerService {
  Dio dio = Dio();
  var storage = const FlutterSecureStorage();

  getAvailableDevices() async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await retry(() async {
        return await dio.get(
          '/me/player/devices',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );
      }, retryIf: (e) async {
        if (e is DioException && e.response!.statusMessage == 'Unauthorized') {
          await AuthController().syncSpotifyRemote(forceTokenRefresh: true);
          accessToken = await storage.read(key: 'accessToken');
          return true;
        }

        return false;
      });
      // debug only
      log(response.data);
    } on Exception {
      rethrow;
    }
  }
}
