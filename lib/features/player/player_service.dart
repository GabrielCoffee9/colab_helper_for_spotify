import '../../models/secundary models/devices_model.dart';
import '../../models/secundary models/queue_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PlayerService {
  Dio dio = Dio();
  var storage = const FlutterSecureStorage();

  PlayerService() {
    dio.options.baseUrl = 'https://api.spotify.com/v1';
  }

  Future<List<Devices>> getAvailableDevices() async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/me/player/devices',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

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
      await dio.put(
        '/me/player',
        data: {
          "device_ids": [deviceId]
        },
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        }),
      );
    } on Exception {
      rethrow;
    }
  }

  Future<Queue> getUserQueue() async {
    try {
      var accessToken = await storage.read(key: 'accessToken');

      final response = await dio.get(
        '/me/player/queue',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      Queue userQueue = Queue.fromJson(response.data);

      return userQueue;
    } on Exception {
      rethrow;
    }
  }
}
