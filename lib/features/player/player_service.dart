import 'dart:developer';

import 'package:colab_helper_for_spotify/features/auth/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retry/retry.dart';

class PlayerService {
  Dio dio = Dio();
  var storage = const FlutterSecureStorage();

  getAvailableDevices() async {
    final response = await retry(() async {
      var accessToken = await storage.read(key: 'accessToken');

      return await dio.get(
        '/me/player/devices',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        }, contentType: Headers.jsonContentType),
      );
    }, retryIf: (e) async {
      if (e is DioError && e.response!.statusMessage == 'Unauthorized') {
        return await AuthController().verifySync();
      }

      return false;
    });

    log(response.data);
  }
}
