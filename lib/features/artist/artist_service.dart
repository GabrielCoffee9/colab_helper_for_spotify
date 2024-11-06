import '../../shared/modules/network/http.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ArtistService {
  final dio = Http.instance.dio;
  var storage = const FlutterSecureStorage();

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

  Future<Response<dynamic>> getTopTracks(
    String artistId,
    String market,
  ) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/artists/$artistId/top-tracks',
        queryParameters: {'market': market},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }
}
