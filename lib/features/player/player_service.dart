import 'package:colab_helper_for_spotify/features/auth/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retry/retry.dart';

import '../../models/secundary models/devices.dart';

class PlayerService {
  Dio dio = Dio();
  var storage = const FlutterSecureStorage();

  PlayerService() {
    dio.options.baseUrl = 'https://api.spotify.com/v1';
  }

  Future<List<Devices>> getAvailableDevices() async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await retry(() async {
        return await dio.get(
          '/me/player/devices',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );
      }, retryIf: (e) async {
        if (e is DioException && e.response!.statusMessage == 'Unauthorized') {
          await AuthController.instance
              .syncSpotifyRemote(forceTokenRefresh: true);
          accessToken = await storage.read(key: 'accessToken');
          return true;
        }

        return false;
      });
      List<Devices> devicesList = [];

      for (var element in response.data['devices']) {
        var newDevice = Devices.fromJson(element);

        devicesList.add(newDevice);
      }

      return devicesList;
    } on Exception {
      rethrow;
    }
  }

  transferPlayback(String deviceId) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      await retry(() async {
        return await dio.put(
          '/me/player',
          data: {
            "device_ids": [deviceId]
          },
          options: Options(headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          }),
        );
      }, retryIf: (e) async {
        if (e is DioException && e.response!.statusMessage == 'Unauthorized') {
          await AuthController.instance
              .syncSpotifyRemote(forceTokenRefresh: true);
          accessToken = await storage.read(key: 'accessToken');
          return true;
        }

        return false;
      });
    } on Exception {
      rethrow;
    }
  }

  getPlayblackState(String userCountryCode) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      await retry(() async {
        return await dio.get(
          '/me/player',
          queryParameters: {'market': userCountryCode},
          data: {"device_ids": []},
          options: Options(headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          }),
        );
      }, retryIf: (e) async {
        if (e is DioException && e.response!.statusMessage == 'Unauthorized') {
          await AuthController.instance
              .syncSpotifyRemote(forceTokenRefresh: true);
          accessToken = await storage.read(key: 'accessToken');
          return true;
        }

        return false;
      });
    } on Exception {
      rethrow;
    }
  }
}
