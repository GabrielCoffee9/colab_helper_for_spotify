import '../../shared/modules/network/http.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PlayerService {
  final dio = Http.instance.dio;
  var storage = const FlutterSecureStorage();

  PlayerService();

  Future<Response<dynamic>> getAvailableDevices() async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/me/player/devices',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }

  Future<Response<dynamic>> transferPlayback(String deviceId) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.put(
        '/me/player',
        data: {
          "device_ids": [deviceId]
        },
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        }),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }

  Future<Response<dynamic>> getUserQueue() async {
    try {
      var accessToken = await storage.read(key: 'accessToken');

      final response = await dio.get(
        '/me/player/queue',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }
}
