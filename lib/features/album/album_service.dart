import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../shared/modules/network/http.dart';

class AlbumService {
  final dio = Http.instance.dio;
  var storage = const FlutterSecureStorage();

  Future<Response<dynamic>> getAlbumInformation(
      String albumId, String market) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/albums/$albumId',
        queryParameters: {
          'market': market,
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }

  Future<Response<dynamic>> getAlbumTracks(
      String albumId, String market, int offset) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/albums/$albumId/tracks',
        queryParameters: {
          'limit': 50,
          'market': market,
          'offset': offset,
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }

  Future<Response<dynamic>> getArtist(String artistId) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/artists/$artistId',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }
}
